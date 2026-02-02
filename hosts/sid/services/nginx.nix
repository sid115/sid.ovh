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
    virtualHosts."${constants.services.forgejo.fqdn}" = mkVirtualHost {
      inherit ssl;
      address = constants.hosts.rx4.ip;
      port = constants.services.forgejo.port;
    };
    virtualHosts."${constants.services.miniflux.fqdn}" = mkVirtualHost {
      inherit ssl;
      port = constants.services.miniflux.port;
    };
    virtualHosts."${constants.services.netdata.fqdn}" = mkVirtualHost {
      ssl = false;
      port = constants.services.netdata.port;
    };
    virtualHosts."${constants.services.open-webui-oci.fqdn}" = mkVirtualHost {
      inherit ssl;
      address = constants.hosts.rx4.ip;
      port = constants.services.open-webui-oci.port;
    };
    virtualHosts."${constants.services.rss-bridge.fqdn}" = {
      enableACME = ssl;
      forceSSL = ssl;
      locations."/" = {
        proxyPass = "http://${constants.hosts.rx4.ip}";
      };
    };
    # FIXME
    # virtualHosts."print.sid.ovh" = {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://100.64.0.5:631";
    #     proxyWebsockets = true;
    #   };
    # };
  };
}
