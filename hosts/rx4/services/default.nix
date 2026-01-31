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
    ./print-server.nix

    # ./alditalk-extender.nix # FIXME
  ];

  services.transmission.enable = true;
}
