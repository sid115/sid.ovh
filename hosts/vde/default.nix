{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./secrets
    ./services
    ./virtualisation.nix

    ../../users/sid

    inputs.core.nixosModules.common

    outputs.nixosModules.common
  ];

  networking.hostName = "vde";
  networking.domain = "vde.lan";

  system.stateVersion = "25.11";
}
