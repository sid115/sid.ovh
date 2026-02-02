{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.openssh

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

  services.transmission.enable = true;
}
