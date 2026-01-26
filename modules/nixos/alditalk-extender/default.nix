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

    package = mkPackageOption pkgs "alditalk-true-unlimited" { };

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
    users = {
      users = {
        alditalk = {
          isSystemUser = true;
          group = "alditalk";
          home = "/var/lib/alditalk";
          createHome = true;
          description = "AldiTalk Extender Service User";
        };
      };
      groups.alditalk = { };
    };

    systemd.services.alditalk-extender = {
      description = "AldiTalk True Unlimited Extender";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = getExe cfg.package;
        EnvironmentFile = cfg.envFile;
        Environment = "HOME=/var/lib/alditalk";

        Restart = "always";
        RestartSec = "30s";
        User = "alditalk";
        Group = "alditalk";
        WorkingDirectory = "/var/lib/alditalk";

        RuntimeDirectory = "alditalk";
        ProtectSystem = "full";
        PrivateTmp = true;
        NoNewPrivileges = false;
      };
    };
  };
}
