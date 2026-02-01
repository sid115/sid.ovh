{
  inputs,
  constants,
  lib,
  ...
}:

let
  ssl = true;

  inherit (lib.utils) mkVirtualHost;
in
{
  imports = [
    inputs.core.nixosModules.nginx
  ];

  services.nginx = {
    enable = true;
    openFirewall = true;
    forceSSL = ssl;
    virtualHosts."${constants.services.open-webui-oci.fqdn}" = mkVirtualHost {
      inherit ssl;
      address = constants.hosts.rx4.ip;
      port = constants.services.open-webui-oci.port;
    };
    virtualHosts."${constants.services.forgejo.fqdn}" = mkVirtualHost {
      inherit ssl;
      address = constants.hosts.rx4.ip;
      port = constants.services.forgejo.port;
    };
    virtualHosts."${constants.services.netdata.fqdn}" = mkVirtualHost {
      ssl = false;
      port = constants.services.netdata.port;
    };
    # FIXME
    #   virtualHosts."print.sid.ovh" = {
    #     enableACME = true;
    #     forceSSL = true;
    #     locations."/" = {
    #       proxyPass = "http://100.64.0.5:631";
    #       proxyWebsockets = true;
    #     };
    #   };
    # FIXME
    #   virtualHosts."rss.sid.ovh" = {
    #     enableACME = true;
    #     forceSSL = true;
    #     locations."/" = {
    #       proxyPass = "http://100.64.0.5:8085";
    #     };
    #   };
  };
}
