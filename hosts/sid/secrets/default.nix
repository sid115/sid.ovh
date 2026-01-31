{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.secrets."netdata/stream/rx4/uuid" = {
    owner = config.services.netdata.user;
    group = config.services.netdata.group;
    mode = "0400";
    restartUnits = [ "netdata.service" ];
  };

  # parent node
  sops.templates."netdata/stream.conf" = {
    owner = config.services.netdata.user;
    group = config.services.netdata.group;
    mode = "0400";
    restartUnits = [ "netdata.service" ];
    content = ''
      [${config.sops.placeholder."netdata/stream/rx4/uuid"}]
      enabled = yes
      default history = 3600
    '';
  };
}
