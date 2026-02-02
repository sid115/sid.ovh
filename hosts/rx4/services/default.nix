{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.openssh
    inputs.clients.nixosModules.syncthing

    outputs.nixosModules.tailscale

    ./forgejo.nix
    ./miniflux.nix
    ./netdata.nix
    ./nginx.nix
    ./open-webui-oci.nix
    ./print-server.nix
    ./rss-bridge.nix

    # ./alditalk-extender.nix # FIXME
  ];

  # bootstrap
  # services.syncthing.enable = true;
  # services.syncthing.guiAddress = "0.0.0.0:8384";

  services.transmission.enable = true;
}
