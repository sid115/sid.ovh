{
  inputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.nginx
  ];

  services.nginx = {
    enable = true;
    openFirewall = false;
    forceSSL = false;
  };
}
