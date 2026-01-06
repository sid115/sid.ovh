{
  description = "NixOS configurations for machines behind sid.ovh.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    core = {
      type = "gitlab";
      owner = "sid";
      repo = "nix-core";
      host = "git.portuus.de";
      ref = "feature/matrix-overhaul";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # core.url = "git+file:///home/sid/src/nix-core";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    headplane.url = "github:tale/headplane";
    headplane.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      supportedSystems = [
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      overlays = [ inputs.core.overlays.default ];

      mkNixosConfiguration =
        system: modules:
        nixpkgs.lib.nixosSystem {
          inherit system modules;
          specialArgs = {
            inherit inputs outputs;
            lib =
              (import nixpkgs {
                inherit system overlays;
              }).lib;
          };
        };

      mkNode = name: system: {
        hostname = name;
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
        };
      };
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;

      nixosConfigurations = {
        rx4 = mkNixosConfiguration "x86_64-linux" [ ./hosts/rx4 ];
        sid = mkNixosConfiguration "x86_64-linux" [ ./hosts/sid ];
        vde = mkNixosConfiguration "x86_64-linux" [ ./hosts/vde ];
      };

      deploy = {
        nodes = {
          rx4 = mkNode "rx4" "x86_64-linux";
          sid = mkNode "sid" "x86_64-linux";
          vde = mkNode "vde" "x86_64-linux";
        };
      };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          flakePkgs = self.packages.${system};
          deployChecks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
        in
        deployChecks
        // {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
            };
          };
          build-packages = pkgs.linkFarm "flake-packages-${system}" flakePkgs;
        }
      );
    };
}
