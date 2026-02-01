{
  inputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.nginx
  ];

  services.nginx = {
    enable = true;
    openFirewall = true;
    forceSSL = true;
    virtualHosts."ai.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://100.64.0.10:8083";
        proxyWebsockets = true;
      };
    };
    virtualHosts."git.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://100.64.0.10:3456";
        proxyWebsockets = true;
      };
    };
    virtualHosts."netdata.sid.tail" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:19999";
      };
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
