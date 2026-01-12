{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    # ./monero.nix
    ./packages.nix
    ./secrets
    ./virtualisation.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.tailscale
  ];

  networking.hostName = "vde";
  networking.domain = "vde.lan";

  system.stateVersion = "25.11";
}
