{ config, lib, inputs, ... }:
with lib;

let
  cfg = config.knix.root-on-tmpfs;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.knix.root-on-tmpfs = {
    enable = mkEnableOption "Root on tmpfs";
    persistDirectory = mkOption {
      type = types.path;
      default = "/nix/persist";
    };
  };

  config = mkIf cfg.enable {
    environment.persistence.${cfg.persistDirectory} = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/log" # Logs duh...
        "/var/lib/nixos" # NixOS state stuff
        "/var/lib/systemd/timers" # Persistent Timers
        "/var/lib/private" # Maybe useless?
        # "/var/lib/btrfs" # Maybe add?
        "/var/lib/lastlog" # Login history
        "/etc/nixos"
      ]
      ++ optionals config.hardware.bluetooth.enable [ "/var/lib/bluetooth" ]
      ++ optionals config.systemd.coredump.enable [ "/var/lib/systemd/coredump" ]
      ++ optionals config.networking.networkmanager.enable [
        "/etc/NetworkManager/system-connections" # NetworkManager connections
        "/var/lib/NetworkManager" # NetworkManager state
      ]
      ++ optionals config.boot.lanzaboote.enable [ config.boot.lanzaboote.pkiBundle ] # Secureboot keys
      ++ optionals config.services.colord.enable [
        { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; } # Color management
      ]
      ++ optionals config.services.hardware.bolt.enable [ "/var/lib/boltd" ] # Thunderbolt settings
      ++ optionals config.services.fwupd.enable [ "/var/lib/fwupd" ] # Firmware update history
      ++ optionals config.services.fprintd.enable [ "/var/lib/fprint" ] # Enrolled fingerprints
      ++ optionals config.services.upower.enable [ "/var/lib/upower" ] # Battery history
      ++ optionals config.services.accounts-daemon.enable [ "/var/lib/AccountsService" ] # User metadata
      ++ optionals config.services.power-profiles-daemon.enable [ "/var/lib/power-profiles-daemon" ] # Stores selected power profile
      ++ optionals config.services.flatpak.enable [ "/var/lib/flatpak" ]
      ++ optionals config.services.logrotate.enable [ "/var/lib/logrotate" ]
      ++ optionals config.knix.desktop.gnome.copyMonitors.enable [ "/var/lib/gnome-copy-monitors" ];
      files = [
        "/etc/machine-id"
        # SSH
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    # Change logrotate state file path for preserving with impermanence
    services.logrotate.extraArgs = lib.mkAfter [ "--state" "/var/lib/logrotate/logrotate.status" ];

    # Fix Agenix decryption when using Impermanence [+5 hours wasted on this]
    services.openssh.hostKeys = let basePath = "${cfg.persistDirectory}/etc/ssh"; in [
      { path = "${basePath}/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
      { path = "${basePath}/ssh_host_ed25519_key"; type = "ed25519"; }
    ];
    # Use same keys even if `services.openssh.enable` is disabled
    age.identityPaths = map (e: e.path) (
      lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
    );

    # /tmp on separate tmpfs
    boot.tmp = {
      useTmpfs = true;
      tmpfsSize = "12G";
    };
  };
}
