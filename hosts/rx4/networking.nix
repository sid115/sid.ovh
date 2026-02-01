{
  networking.hostName = "rx4";
  networking.domain = "sid.ovh";

  # boot.kernel.sysctl = {
  #   "net.ipv4.conf.all.forwarding" = 1;
  #   "net.ipv6.conf.all.forwarding" = 1;
  # };
  #
  # networking.interfaces.enp2s0 = {
  #   useDHCP = false;
  #   ipv4.addresses = [
  #     {
  #       address = "192.168.100.1";
  #       prefixLength = 24;
  #     }
  #   ];
  # };
  #
  # networking.nat = {
  #   enable = true;
  #   internalInterfaces = [ "enp2s0" ];
  #   externalInterface = "enp0s20f0u1";
  # };
  #
  # services.dnsmasq = {
  #   enable = true;
  #   settings = {
  #     interface = "enp2s0";
  #     bind-interfaces = true;
  #     dhcp-range = "192.168.100.10,192.168.100.50,24h";
  #     dhcp-option = [
  #       "3,192.168.100.1" # default Gateway
  #       "6,192.168.100.1" # DNS
  #     ];
  #   };
  # };
  #
  # networking.firewall.interfaces."enp2s0" = {
  #   allowedUDPPorts = [
  #     53
  #     67
  #   ];
  #   allowedTCPPorts = [ 53 ];
  # };
  #
  # networking.firewall.extraCommands = ''
  #   iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
  #   iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
  # '';
}
