rec {
  domain = "sid.ovh";
  hosts = {
    sid = {
      ip = "100.64.0.6";
    };
    rx4 = {
      ip = "100.64.0.10";
    };
  };
  services = {
    forgejo = {
      fqdn = "git." + domain;
      port = 3456;
    };
    miniflux = {
      fqdn = "rss." + domain;
      port = 8085;
    };
    netdata = {
      fqdn = "netdata.sid.tail";
      port = 19999;
    };
    open-webui-oci = {
      fqdn = "ai." + domain;
      port = 8083;
    };
    rss-bridge = rec {
      subdomain = "rss-bridge";
      fqdn = subdomain + "." + domain;
    };
  };
}
