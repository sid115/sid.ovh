{ outputs, ... }:

{
  imports = [
    outputs.nixosModules.monero
  ];

  monero = {
    enable = true;
    mining.address = "";
  };
  xmrig.settings = {
    cpu = {
      max-threads-hint = 4;
    };
  };
}
