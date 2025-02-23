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
}
