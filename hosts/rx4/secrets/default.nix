{ inputs, config, ... }:

let
  alditalk = config.services.alditalk-extender.user;
in
{
  imports = [ inputs.core.nixosModules.sops ];

  sops.secrets = {
    "alditalk/username" = {
      owner = alditalk;
      group = alditalk;
      mode = "0400";
    };
    "alditalk/password" = {
      owner = alditalk;
      group = alditalk;
      mode = "0400";
    };
  };

  sops.templates = {
    alditalk-extender = {
      owner = alditalk;
      group = alditalk;
      mode = "0400";
      content = ''
        USERNAME=${config.sops.placeholder."alditalk/username"}
        PASSWORD=${config.sops.placeholder."alditalk/password"}
      '';
    };
  };
}
