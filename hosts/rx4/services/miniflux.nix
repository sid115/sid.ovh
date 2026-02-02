{ inputs, constants, ... }:

{
  imports = [ inputs.core.nixosModules.miniflux ];

  services.miniflux = {
    enable = true;
    config = {
      ADMIN_USERNAME = "sid";
      PORT = constants.services.miniflux.port;
    };
  };
}
