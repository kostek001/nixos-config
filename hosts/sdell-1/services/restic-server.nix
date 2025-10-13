{ config, inputs, system, ... }:

{
  age.secrets."self.resticServer_htpasswd" = {
    file = ./../secrets/resticServer_htpasswd.age;
    owner = config.systemd.services.restic-rest-server.serviceConfig.User;
    group = config.systemd.services.restic-rest-server.serviceConfig.Group;
  };
  age.secrets."self.resticServer_tlsCert" = {
    file = ./../secrets/resticServer_tlsCert.age;
    owner = config.systemd.services.restic-rest-server.serviceConfig.User;
    group = config.systemd.services.restic-rest-server.serviceConfig.Group;
  };
  age.secrets."self.resticServer_tlsKey" = {
    file = ./../secrets/resticServer_tlsKey.age;
    owner = config.systemd.services.restic-rest-server.serviceConfig.User;
    group = config.systemd.services.restic-rest-server.serviceConfig.Group;
  };

  services.restic.server = {
    enable = true;
    listenAddress = "8001";
    privateRepos = true;
    dataDir = "/mnt/s0-point1/restic-server";
    # Only bcrypt is supported. Use `htpasswd -n -B user` to generate
    htpasswd-file = config.age.secrets."self.resticServer_htpasswd".path;
    extraFlags = [
      "--tls"

      "--tls-cert"
      "${config.age.secrets."self.resticServer_tlsCert".path}"

      "--tls-key"
      "${config.age.secrets."self.resticServer_tlsKey".path}"

      "--tls-min-ver"
      "1.3"
    ];
  };

  networking.firewall.interfaces.vlan20.allowedTCPPorts = [ 8001 ];

  # TODO: remove if updated
  # Version 0.14.0 from nixpkgs-unstable. Remove if same or higher on stable channel.
  nixpkgs.overlays = [
    (final: prev: {
      restic-rest-server = inputs.nixpkgs-unstable.legacyPackages.${system}.restic-rest-server;
    })
  ];
}
