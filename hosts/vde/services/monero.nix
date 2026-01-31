{ outputs, ... }:

{
  imports = [
    outputs.nixosModules.monero
  ];

  services = {
    monero = {
      enable = true;
      mining.address = "";
    };
    xmrig.settings = {
      cpu = {
        max-threads-hint = 4;
      };
    };
  };
}
