{
  outputs,
  ...
}:

{
  imports = [ outputs.nixosModules.forgejo ];

  services.forgejo = {
    enable = true;
  };
}
