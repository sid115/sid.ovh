{ config, pkgs, ... }:

let
  user = "github-runner-tailnet-deploy";
  group = user;

  tokenFile = config.sops.secrets."github-runners/tailnet-deploy/token".path;
  deployKeyFile = config.sops.secrets."github-runners/tailnet-deploy/deploy-key".path;
in
{
  services.github-runners = {
    tailnet-deploy = {
      enable = true;
      url = "https://github.com/sid115/sid.ovh";
      inherit tokenFile user group;

      extraPackages = with pkgs; [
        deploy-rs
        git
        nix
        openssh
      ];

      serviceOverrids = {
        BindReadOnlyPaths = [ "${deployKeyFile}:/root/.ssh/id_ed25519" ];
      };
    };
  };

  nix.settings.trusted-users = [ user ];

  sops =
    let
      owner = user;
      group = group;
      mode = "0400";
    in
    {
      secrets."github-runners/tailnet-deploy/token" = {
        inherit owner group mode;
      };
      secrets."github-runners/tailnet-deploy/deploy-key" = {
        inherit owner group mode;
      };
    };
}
