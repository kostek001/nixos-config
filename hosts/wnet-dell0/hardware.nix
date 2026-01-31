{ config, lib, pkgs, ... }:

{
  ## BOOTLOADER
  knix.boot.loader.lanzaboote.enable = true;

  ## IMPERMANENCE
  fileSystems."/nix/persist".neededForBoot = true;
  environment.persistence."/nix/persist" = {
    enable = true;
    hideMounts = true;
    # TODO: move common directories/files to standalone module
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers" # Persistent Timers
      "/etc/NetworkManager/system-connections" # NetworkManager connections
      "/var/lib/NetworkManager" # NetworkManager state
      config.boot.lanzaboote.pkiBundle # Secureboot keys
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      "/var/lib/boltd" # Thunderbolt settings
      "/var/lib/fwupd" # Firmware updates
      "/var/lib/private" # Maybe useless?
      # "/var/lib/btrfs" # Maybe add?
      "/var/lib/fprint" # Enrolled fingerprints
      "/var/lib/upower" # Battery history graphs
      "/var/lib/AccountsService" # User metadata
      "/var/lib/power-profiles-daemon" # Stores power profile "balansed"/"power saver"
      "/var/lib/flatpak"
      "/var/lib/lastlog" # Login history
      "/var/lib/logrotate"

      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
      # SSH
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/usr/gnome/monitors.xml"
    ];
  };

  # Change logrotate state file path for preserving with impermanence
  services.logrotate.extraArgs = lib.mkAfter [ "--state" "/var/lib/logrotate/logrotate.status" ];

  # Fix Agenix decryption when using Impermanence
  services.openssh.hostKeys = let basePath = "/nix/persist/etc/ssh"; in [
    { path = "${basePath}/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
    { path = "${basePath}/ssh_host_ed25519_key"; type = "ed25519"; }
  ];

  # /tmp on Tmpfs
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "12G";
  };

  ## GRAPHICS
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };
  boot.kernelParams = [
    # See https://discourse.nixos.org/t/i915-driver-has-bug-for-iris-xe-graphics/25006/12
    "i915.enable_psr=0"
  ];

  ## WEBCAM
  # Make the webcam work (needs Linux >= 6.6):
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6ep";

  ## FINGERPRINT
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-broadcom;
}
