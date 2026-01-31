{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.mailserver ];

  mailserver = {
    enable = true;
    stateVersion = 3;
    accounts = {
      sid = {
        aliases = [ "postmaster" ];
      };
    };
  };
}
