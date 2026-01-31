{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.smtp-relay ];

  services.smtp-relay = {
    enable = true;
    subdomain = "mail";
    mailserverIP = "100.65.0.7"; # host `vde`
  };
}
