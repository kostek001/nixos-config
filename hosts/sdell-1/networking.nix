{
  networking.useDHCP = false;
  networking.useNetworkd = true;

  networking.vlans = {
    vlan1 = {
      id = 1;
      interface = "ether0";
    };
    vlan20 = {
      id = 20;
      interface = "ether0";
    };
  };
  networking.interfaces = {
    vlan20.ipv4.addresses = [{
      address = "192.168.20.13";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = {
    address = "192.168.20.1";
    interface = "vlan20";
  };
  networking.nameservers = [ "192.168.20.1" ];

  ## FIREWALL
  networking.nftables.enable = true;
  networking.firewall.filterForward = true;

  # Restrict SSH to vlan20
  services.openssh.openFirewall = false;
  networking.firewall.interfaces.vlan20.allowedTCPPorts = [ 22 ];
}
