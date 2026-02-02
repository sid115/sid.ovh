# Troubleshooting:
# Cannot connect to the Docker daemon at unix:///var/run/docker.sock
# sudo systemctl restart podman.socket gitlab.service gitlab-runner.service

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.forgejo-runner;

  inherit (lib)
    concatStringsSep
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    types
    ;

  initScript = pkgs.writeShellScript "nix-init.sh" ''
    mkdir -p -m 0755 /nix/var/log/nix/drvs
    mkdir -p -m 0755 /nix/var/nix/gcroots
    mkdir -p -m 0755 /nix/var/nix/profiles
    mkdir -p -m 0755 /nix/var/nix/temproots
    mkdir -p -m 0755 /nix/var/nix/userpool
    mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
    mkdir -p -m 1777 /nix/var/nix/profiles/per-user
    mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
    mkdir -p -m 0700 "$HOME/.nix-defexpr"
    . ${pkgs.nix}/etc/profile.d/nix-daemon.sh
    ${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/${cfg.nixosChannel} nixpkgs
    ${pkgs.nix}/bin/nix-channel --update nixpkgs
    ${pkgs.nix}/bin/nix-env -i ${
      concatStringsSep " " (
        with pkgs;
        [
          nix
          cacert
          git
          openssh
        ]
      )
    }
  '';
in

{
  options.services.forgejo-runner = {
    enable = mkEnableOption "Nix-based Forgejo Runner service";
    url = mkOption {
      type = types.str;
      description = "Forgejo instance URL.";
    };
    tokenFile = mkOption {
      type = types.path;
      description = "Path to EnvironmentFile containing TOKEN=...";
    };
    nixosChannel = mkOption {
      type = types.str;
      default = "nixos-unstable";
      description = "NixOS channel to use inside the containers.";
    };
    containerRuntime = mkOption {
      type = types.enum [
        "docker"
        "podman"
      ];
      default = "podman";
      description = "The container runtime engine to use.";
    };
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl."net.ipv4.ip_forward" = true;

    virtualisation = {
      docker.enable = cfg.containerRuntime == "docker";
      podman = optionalAttrs (cfg.containerRuntime == "podman") {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
    };
    systemd.sockets.podman = optionalAttrs (cfg.containerRuntime == "podman") {
      socketConfig.Symlinks = [ "/var/run/docker.sock" ];
    };

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        name = "${config.networking.hostName}-nix";
        inherit (cfg) url tokenFile;

        labels = [ "nix-alpine:docker://alpine" ];

        settings = {
          container = {
            volumes = [
              "/nix/store:/nix/store:ro"
              "/nix/var/nix/db:/nix/var/nix/db:ro"
              "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
              "${initScript}:/etc/profile.d/nix-init.sh:ro"
            ];
            options = "--env ENV=/etc/profile.d/nix-init.sh --env BASH_ENV=/etc/profile.d/nix-init.sh";
          };
          host.envs = {
            ENV = "/etc/profile";
            NIX_REMOTE = "daemon";
            USER = "root";
            PATH = "/nix/var/nix/profiles/default/bin:/bin:/sbin:/usr/bin:/usr/sbin";
            NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
            NIX_CONFIG = "extra-experimental-features = nix-command flakes";
          };
        };
      };
    };
  };
}
