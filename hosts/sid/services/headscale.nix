{
  inputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.headplane
    inputs.core.nixosModules.headscale
  ];

  services.headplane = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "hp";
    };
  };

  services.headscale = {
    enable = true;
    openFirewall = true;
    reverseProxy = {
      enable = true;
      subdomain = "hs";
    };
  };
}
