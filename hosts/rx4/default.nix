{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./packages.nix
    ./secrets
    ./services

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.server

    outputs.nixosModules.common
  ];

  system.stateVersion = "25.11";
}
