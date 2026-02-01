{
  config,
  lib,
  ...
}:

let
  cfg = config.services.forgejo;

  inherit (cfg) settings;
  inherit (lib) head mkDefault mkIf;
in
{
  config = mkIf cfg.enable {
    services.forgejo = {
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.${config.networking.domain}";
          PROTOCOL = "https";
          ROOT_URL = with settings.server; "${PROTOCOL}://${DOMAIN}/";
          HTTP_ADDR = "0.0.0.0";
          HTTP_PORT = 3456;
          SSH_PORT = head config.services.openssh.ports;
        };
        service = {
          DISABLE_REGISTRATION = false;
        };
        actions = {
          ENABLED = mkDefault false;
        };
        mailer = {
          ENABLED = mkDefault false;
          SMTP_ADDR = "mail.${config.networking.domain}";
          FROM = "git@${settings.server.DOMAIN}";
          USER = "git@${settings.server.DOMAIN}";
        };
      };
      secrets = {
        mailer.PASSWD = mkIf settings.mailer.ENABLED config.sops.secrets."forgejo/mail-pw".path;
      };
    };

    sops.secrets."forgejo/mail-pw" = mkIf settings.mailer.ENABLED {
      owner = cfg.user;
      group = cfg.group;
      mode = "0400";
    };
  };
}
