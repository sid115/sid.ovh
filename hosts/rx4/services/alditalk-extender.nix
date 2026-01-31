{
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    outputs.nixosModules.alditalk-extender
  ];

  services.alditalk-extender = {
    enable = true;
    package = pkgs.local.alditalk-true-unlimited;
    envFile = config.sops.templates.alditalk-extender.path;
  };

  sops.secrets = {
    "alditalk/username" = {
      owner = "alditalk";
      group = "alditalk";
      mode = "0400";
    };
    "alditalk/password" = {
      owner = "alditalk";
      group = "alditalk";
      mode = "0400";
    };
  };

  sops.templates = {
    alditalk-extender = {
      owner = "alditalk";
      group = "alditalk";
      mode = "0400";
      content = ''
        USERNAME=${config.sops.placeholder."alditalk/username"}
        PASSWORD=${config.sops.placeholder."alditalk/password"}
      '';
    };
  };
}
