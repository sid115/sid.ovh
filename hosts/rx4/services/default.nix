{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.openssh

    outputs.nixosModules.tailscale

    ./netdata.nix
    ./open-webui-oci.nix
    ./print-server.nix

    # ./alditalk-extender.nix # FIXME
  ];

  services.transmission.enable = true;
}
