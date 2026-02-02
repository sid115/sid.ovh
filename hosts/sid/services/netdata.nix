{
  config,
  pkgs,
  ...
}:

let
  email = "sid@${config.networking.domain}";
in
{
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override {
      withCloudUi = true;
    };
    config.global = {
      "debug log" = "syslog";
      "access log" = "syslog";
      "error log" = "syslog";
    };
    configDir = {
      "stream.conf" = config.sops.templates."netdata/stream.conf".path;
      "health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" ''
        SEND_EMAIL="YES"
        sendmail="/run/wrappers/bin/sendmail"
        EMAIL_SENDER="netdata@${config.networking.domain}"
        DEFAULT_RECIPIENT_EMAIL="${email}"
        role_recipients_email[sysadmin]="${email}"
        role_recipients_email[domainadmin]="${email}"
        role_recipients_email[root]="${email}"
      '';
    };
  };

  systemd.services.netdata.environment = {
    NETDATA_USER_CONFIG_DIR = "/etc/netdata/conf.d";
  };

  sops =
    let
      owner = config.services.netdata.user;
      group = config.services.netdata.group;
      mode = "0400";
      restartUnits = [ "netdata.service" ];
    in
    {
      secrets."netdata/stream/rx4/uuid" = {
        inherit
          owner
          group
          mode
          restartUnits
          ;
      };

      templates."netdata/stream.conf" = {
        inherit
          owner
          group
          mode
          restartUnits
          ;
        # parent node
        content = ''
          [${config.sops.placeholder."netdata/stream/rx4/uuid"}]
          enabled = yes
          default history = 3600
        '';
      };
    };
}
