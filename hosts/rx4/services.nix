{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.print-server
    # outputs.nixosModules.alditalk-extender
  ];

  # services.alditalk-extender = {
  #   enable = true;
  #   package = pkgs.local.alditalk-true-unlimited;
  #   envFile = config.sops.templates.alditalk-extender.path;
  # };

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

  services.openssh.enable = true;

  services.print-server.enable = true;

  services.transmission.enable = true;
}
