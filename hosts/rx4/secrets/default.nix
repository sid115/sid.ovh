{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  # sops.secrets = {
  #   "alditalk/username" = {
  #     owner = "alditalk";
  #     group = "alditalk";
  #     mode = "0400";
  #   };
  #   "alditalk/password" = {
  #     owner = "alditalk";
  #     group = "alditalk";
  #     mode = "0400";
  #   };
  # };
  #
  # sops.templates = {
  #   alditalk-extender = {
  #     owner = "alditalk";
  #     group = "alditalk";
  #     mode = "0400";
  #     content = ''
  #       USERNAME=${config.sops.placeholder."alditalk/username"}
  #       PASSWORD=${config.sops.placeholder."alditalk/password"}
  #     '';
  #   };
  # };

  # generate with `uuidgen`
  sops.secrets."netdata/stream/rx4/uuid" = {
    owner = config.services.netdata.user;
    group = config.services.netdata.group;
    mode = "0400";
    restartUnits = [ "netdata.service" ];
  };

  # child node
  sops.templates."netdata/stream.conf" = {
    owner = config.services.netdata.user;
    group = config.services.netdata.group;
    mode = "0400";
    restartUnits = [ "netdata.service" ];
    content = ''
      [stream]
      enabled = yes
      destination = 100.64.0.6:19999
      api key = ${config.sops.placeholder."netdata/stream/rx4/uuid"}
    '';
  };
}
