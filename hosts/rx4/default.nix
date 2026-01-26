{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    # ./gnome.nix
    ./hardware.nix
    ./networking.nix
    ./packages.nix
    ./secrets
    ./services.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.tailscale
  ];

  system.stateVersion = "25.11";
}
