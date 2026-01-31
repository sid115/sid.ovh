{
  inputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.headplane
    inputs.core.nixosModules.headscale
  ];

  services.resolved.enable = false;
  networking.resolvconf.enable = false;

  networking.nameservers = [ "100.64.0.6" ];

  services.coredns = {
    enable = true;
    config = ''
      .:53 {
        bind 100.64.0.6
        hosts {
          100.64.0.6 sid.tail
          100.64.0.6 netdata.sid.tail
          100.64.0.10 rx4.tail
          fallthrough
        }
        forward . 1.1.1.1
        cache
        log
        errors
      }
    '';
  };

  services.headplane = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "hp";
    };
  };

  services.headscale = {
    enable = true;
    openFirewall = true;
    reverseProxy = {
      enable = true;
      subdomain = "hs";
    };
    settings = {
      dns = {
        magic_dns = true;
        base_domain = "tail";
        search_domains = [ "tail" ];
        override_local_dns = true;
        nameservers = {
          global = [ "1.1.1.1" ];
          split = {
            "tail" = [ "100.64.0.6" ];
          };
        };
      };
    };
  };
}
