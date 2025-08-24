{ pkgs, ... }:

{
  users.mutableUsers = false;
  users.allowNoPasswordLogin = true;
  services.getty = {
    autologinUser = "root";
    extraArgs = [ "--login-pause" ];
  };

  ## GENERAL NETWORKING
  networking.useNetworkd = true;
  networking.useDHCP = false;

  systemd.network.networks."10-ether0" = {
    matchConfig.Name = "ether0";
    address = [ "10.99.0.11/31" ];
    routes = [
      {
        Destination = "0.0.0.0/0";
        Gateway = "10.99.0.10";
        GatewayOnLink = true;
      }
    ];
    networkConfig = {
      DNS = [ "1.1.1.1" ];
    };
  };

  ## FIREWALL
  networking.firewall.enable = true;
  networking.nftables.enable = true;
  networking.firewall.filterForward = true;

  networking.firewall.interfaces.ether0.allowedUDPPorts = [ 21331 ];
  networking.firewall.extraForwardRules = ''
    iifname "awg0" oifname "wg0" accept
  '';

  ## WIREGUARD
  environment.systemPackages = with pkgs; [
    wireguard-tools
    amneziawg-tools
  ];

  # WG0
  systemd.network.config.routeTables.wg0 = 22;
  systemd.network.netdevs."50-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
      MTUBytes = "1300";
    };
    wireguardConfig = {
      PrivateKeyFile = "/srv/secrets/wg0/private-key";
      RouteTable = "wg0";
    };
    wireguardPeers = [
      {
        PublicKey = "fO4beJGkKZxosCZz1qunktieuPyzPnEVKVQNhzanjnA=";
        Endpoint = "pl-waw-wg-101.relays.mullvad.net:51820";
        AllowedIPs = [ "0.0.0.0/0" ];
      }
    ];
  };
  systemd.network.networks.wg0 =
    let
      ip = "10.74.111.35";
    in
    {
      matchConfig.Name = "wg0";
      address = [ "${ip}/32" ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
      routingPolicyRules = [
        {
          Priority = 10000;
          From = ip;
          Table = "wg0";
        }
        {
          Priority = 20000;
          To = ip;
          Table = "wg0";
        }
      ];
    };

  # AWG0
  networking.wg-quick.interfaces.awg0 = {
    type = "amneziawg";
    configFile = "/srv/secrets/awg0/output/server.conf";
  };
  systemd.network.config.routeTables.awg0 = 21;
  systemd.network.networks.awg0 = {
    matchConfig.Name = "awg0";
    addresses = [{
      Address = "10.0.0.1/24";
      AddPrefixRoute = true;
    }];
    networkConfig = {
      IPMasquerade = "ipv4";
      IPv4Forwarding = true;
    };
    # routes = [{
    #   Destination = "10.0.0.0/24";
    #   Source = "10.0.0.1";
    #   Scope = "link";
    #   Table = "awg0";
    # }];
    routingPolicyRules = [
      {
        Priority = 10000;
        From = "10.0.0.1";
        Table = "awg0";
      }
      {
        Priority = 20000;
        To = "10.0.0.1/24";
        Table = "awg0";
      }
      {
        Priority = 30000;
        IncomingInterface = "awg0";
        Table = "wg0";
      }
    ];
  };
}
