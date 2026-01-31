{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.baibot
    inputs.core.nixosModules.coturn
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.maubot
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  services.baibot = {
    enable = true;
    package = pkgs.core.baibot;
  };

  services.coturn = {
    enable = true;
    sops = true;
    openFirewall = true;
  };

  services.matrix-synapse = {
    enable = true;
    sops = true;
    coturn.enable = true;
    bridges = {
      whatsapp = {
        enable = true;
        admin = "@sid:sid.ovh";
      };
      signal = {
        enable = true;
        admin = "@sid:sid.ovh";
      };
    };
  };

  services.maubot = {
    enable = true;
    sops = true;
    admins = [
      "sid"
    ];
    plugins = with config.services.maubot.package.plugins; [
      github
      reminder
    ];
  };
}
