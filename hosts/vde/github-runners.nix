{ config, ... }:

let
  tokenFile = config.sops.secrets."github-runners/vde".path;
in
{
  services.github-runners = {
    "sid.ovh" = {
      enable = true;
      url = "https://github.com/sid115/sid.ovh";
      inherit tokenFile;
    };
  };
}
