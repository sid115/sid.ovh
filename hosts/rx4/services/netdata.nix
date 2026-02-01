{
  config,
  constants,
  ...
}:

{
  services.netdata = {
    enable = true;
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
      # generate with `uuidgen`
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
        # child node
        content = ''
          [stream]
          enabled = yes
          destination = ${constants.hosts.sid.ip}:${builtins.toString constants.services.netdata.port}
          api key = ${config.sops.placeholder."netdata/stream/rx4/uuid"}
        '';
      };
    };
}
