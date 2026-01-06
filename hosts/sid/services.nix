{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.baibot
    inputs.core.nixosModules.coturn
    inputs.core.nixosModules.headplane
    inputs.core.nixosModules.headscale
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.maubot
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.ntfy-sh
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.uptime-kuma
    inputs.core.nixosModules.uptime-kuma-agent

    outputs.nixosModules.tailscale

    # ./smtp-relay.nix # FIXME
  ];

  services.baibot = {
    enable = true;
    package = pkgs.core.baibot;
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
  };

  services.coturn = {
    enable = true;
    sops = true;
    openFirewall = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  services.matrix-synapse = {
    enable = true;
    sops = true;
    coturn.enable = true;
    bridges = {
      whatsapp = {
        enable = true;
        admin = "@sid:sid.ovh";
      };
      signal = {
        enable = true;
        admin = "@sid:sid.ovh";
      };
    };
  };

  services.maubot = {
    enable = true;
    sops = true;
    admins = [
      "sid"
    ];
    plugins = with config.services.maubot.package.plugins; [
      github
      reminder
    ];
  };

  services.nginx = {
    enable = true;
    openFirewall = true;
    forceSSL = true;
    virtualHosts."ai.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://100.64.0.5:8080";
        proxyWebsockets = true;
      };
    };
    virtualHosts."print.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://100.64.0.5:631";
        proxyWebsockets = true;
      };
    };
    virtualHosts."rss.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://100.64.0.5:8085";
      };
    };
  };

  services.ntfy-sh = {
    enable = true;
    reverseProxy.enable = true;
    settings.base-url = "https://ntfy.sid.ovh";
    notifiers = {
      monitor-domains =
        let
          subdomains = [
            "ai"
            "cloud"
            "dav"
            "finance"
            "git"
            "import.finance"
            "media"
            "rss-bridge"
            "share"
            "vault"
            "videos"

            # "miniflux" # FIXME: false positive
            # "search" # FIXME: 429
          ];
        in
        map (subdomain: {
          fqdn = subdomain + ".portuus.de";
          topic = "portuus";
        }) subdomains;
    };
  };

  services.openssh.enable = true;

  services.uptime-kuma = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "kuma";
    };
  };

  services.uptime-kuma-agent = {
    enable = true;
    monitors = {
      nginx = {
        secretFile = config.sops.secrets."uptime-kuma-agent/nginx".path;
      };
      matrix-synapse = {
        secretFile = config.sops.secrets."uptime-kuma-agent/matrix-synapse".path;
      };
      mautrix-whatsapp = {
        secretFile = config.sops.secrets."uptime-kuma-agent/mautrix-whatsapp".path;
      };
      mautrix-signal = {
        secretFile = config.sops.secrets."uptime-kuma-agent/mautrix-signal".path;
      };
    };
  };
}
