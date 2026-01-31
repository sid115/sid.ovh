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

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.server

    outputs.nixosModules.common
  ];

  networking.hostName = "sid";
  networking.domain = "sid.ovh";

  system.stateVersion = "24.11";
}
