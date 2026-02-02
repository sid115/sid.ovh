{ inputs, constants, ... }:

{
  imports = [ inputs.core.nixosModules.rss-bridge ];

  services.rss-bridge = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = constants.services.rss-bridge.subdomain;
      forceSSL = false;
    };
  };
}
