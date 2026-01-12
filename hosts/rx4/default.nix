{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./monero.nix
    ./packages.nix
    ./secrets

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.tailscale
  ];

  networking.hostName = "rx4";
  networking.domain = "rx4.lan";

  services = {
    openssh.enable = true;
    transmission.enable = true;
  };

  system.stateVersion = "25.11";
}
