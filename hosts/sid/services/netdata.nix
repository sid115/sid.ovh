{
  config,
  pkgs,
  ...
}:

{
  # TODO: notifications via mail
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
    };
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
