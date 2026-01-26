{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.alditalk-extender;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{
  options.services.alditalk-extender = {
    enable = mkEnableOption "AldiTalk True Unlimited Extender service";

    package = mkPackageOption pkgs "local.alditalk-true-unlimited";

    user = mkOption {
      type = types.str;
      default = "alditalk";
      description = "User account under which the service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "alditalk";
      description = "Group under which the service runs.";
    };

    envFile = mkOption {
      type = types.path;
      example = "/run/architect/alditalk.env";
      description = ''
        Path to the environment file containing USERNAME and PASSWORD.
        The file should look like:
        USERNAME=0151...
        PASSWORD=yourpassword
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (cfg.user == "alditalk") {
      alditalk = {
        isSystemUser = true;
        group = cfg.group;
        description = "AldiTalk Extender Service User";
      };
    };

    users.groups = mkIf (cfg.group == "alditalk") {
      alditalk = { };
    };

    systemd.services.alditalk-extender = {
      description = "AldiTalk True Unlimited Extender";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = getExe cfg.package;
        EnvironmentFile = cfg.envFile;

        Restart = "always";
        RestartSec = "30s";
        User = cfg.user;
        Group = cfg.group;

        ProtectSystem = "full";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };
  };
}
