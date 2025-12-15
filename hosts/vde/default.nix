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

    # ./github-runners.nix # FIXME
    # ./mailserver.nix # FIXME

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.tailscale
  ];

  networking.hostName = "vde";
  networking.domain = "sid.ovh";

  system.stateVersion = "25.11";
}
