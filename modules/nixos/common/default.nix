{ inputs, ... }:

{
  imports = [
    ./nix.nix
    ./overlays.nix

    inputs.core.nixosModules.device.server
  ];

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./deploy_key.pub
  ];

  nixpkgs.config.allowUnfree = true;
}
