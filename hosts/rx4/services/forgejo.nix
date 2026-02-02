{
  outputs,
  config,
  ...
}:

{
  imports = [
    outputs.nixosModules.forgejo
    outputs.nixosModules.forgejo-runner
  ];

  services.forgejo = {
    enable = true;
  };

  services.forgejo-runner = {
    enable = true;
    url = config.services.forgejo.settings.server.ROOT_URL;
    nixosChannel = "nixos-25.11";
    tokenFile = config.sops.templates."forgejo-runner/token".path;
  };

  sops = {
    secrets."forgejo-runner/token" = { };
    templates."forgejo-runner/token".content = ''
      TOKEN=${config.sops.placeholder."forgejo-runner/token"}
    '';
  };
}
