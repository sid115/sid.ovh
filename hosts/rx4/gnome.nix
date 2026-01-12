{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  services.gnome.gnome-remote-desktop.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # https://github.com/NixOS/nixpkgs/issues/266774#issuecomment-2525412206
  systemd.services."gnome-remote-desktop".wantedBy = [ "graphical.target" ];
  networking.firewall = {
    allowedTCPPorts = [ 3389 ];
    allowedUDPPorts = [ 3389 ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
