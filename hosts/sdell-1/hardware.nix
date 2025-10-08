{ ... }:

{
  ## BOOTLOADER
  knix.boot.loader.lanzaboote.enable = true;

  ## IMPERMANENCE
  fileSystems."/nix/persist".neededForBoot = true;
  environment.persistence."/nix/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/sbctl"
      # 
      "/srv"
    ];
    files = [
      "/etc/machine-id"
      # SSH
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # Fix Agenix decryption when using Impermanence [+5 hours wasted on this]
  services.openssh.hostKeys = let path = "/nix/persist/etc/ssh"; in [
    { path = "${path}/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
    { path = "${path}/ssh_host_ed25519_key"; type = "ed25519"; }
  ];

  # /tmp on Tmpfs
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "12G";
  };

  ## NETWORK
  # Set interface name
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="8c:ec:4b:5b:a8:08", NAME="ether0"
  '';

  ## DISKS
  # s0-point1
  environment.etc.crypttab.text = ''
    luks-s0-point1 UUID=cd97759a-62ee-48c1-b083-b421976367c3 /srv/secrets/s0-point1.key luks
  '';
  fileSystems."/mnt/s0-point1" = {
    device = "/dev/mapper/luks-s0-point1";
    fsType = "btrfs";
    options = [ "subvol=@root" "noatime" "compress=zstd" ];
  };
}
