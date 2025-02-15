{ ... }:

{
  ## BOOTLOADER
  knix.boot.loader.lanzaboote.enable = true;

  ## FILESYSTEMS
  boot.initrd.luks.devices."luks-d8369ae5-6cca-46b6-98b9-a3d925fea0a4".device = "/dev/disk/by-uuid/d8369ae5-6cca-46b6-98b9-a3d925fea0a4";
  # Allow TRIM
  boot.initrd.luks.devices."luks-d8369ae5-6cca-46b6-98b9-a3d925fea0a4".allowDiscards = true;

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=5G" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/luks-d8369ae5-6cca-46b6-98b9-a3d925fea0a4";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ [ "noatime" "compress=zstd" ];
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/luks-d8369ae5-6cca-46b6-98b9-a3d925fea0a4";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ [ "noatime" "compress=zstd" ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/mapper/luks-d8369ae5-6cca-46b6-98b9-a3d925fea0a4";
    fsType = "btrfs";
    options = [ "subvol=@home" ] ++ [ "noatime" "compress=zstd" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/92E2-3821";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  ## IMPERMANENCE
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot" # TODO: remove
      "/var/lib/sbctl"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
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

  ## SWAP
  # fileSystems."/swap" = {
  #   options = [ "noatime" ];
  #   neededForBoot = true;
  # };
  # swapDevices = [{ device = "/swap/swapfile"; }];
}
