{
  description = "NixOS configurations for machines behind sid.ovh.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    core.url = "github:sid115/nix-core/develop";
    # core.url = "git+file:///home/sid/src/nix-core";
    core.inputs.nixpkgs.follows = "nixpkgs";

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
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;

      nixosConfigurations = {
        sid = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/sid ];
        };
        rx4 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/rx4 ];
        };
        vde = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/vde ];
        };
      };

      deploy =
        let
          mkNode = name: {
            hostname = name;
            profiles.system = {
              user = "root";
              path =
                inputs.deploy-rs.lib.${self.nixosConfigurations.${name}.system}.activate.nixos
                  self.nixosConfigurations.${name};
            };
          };
        in
        {
          nodes = {
            sid = mkNode "sid";
            vde = mkNode "vde";
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
