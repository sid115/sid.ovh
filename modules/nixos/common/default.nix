{
  imports = [
    ./nix.nix
    ./overlays.nix
  ];

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./deploy_key.pub
  ];
}
