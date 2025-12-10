{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.secrets."github-runners/vde" = { };
}
