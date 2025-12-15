{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.secrets."github-runners/vde" = { };
  sops.secrets."mailserver/accounts/sid" = { };
}
