{ config, lib, inputs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./customization.nix
  ];

  kostek001.config.type = [ "minimalDesktop" "normalDesktop" "pentesting" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Impermanence
  fileSystems."/persistence".neededForBoot = true;
  environment.persistence."/persistence" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
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

  # Fix Agenix decryption [+5 hours wasted on this]
  services.openssh.hostKeys = let path = "/persistence/etc/ssh"; in [
    { path = "${path}/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
    { path = "${path}/ssh_host_ed25519_key"; type = "ed25519"; }
  ];

  # Hibernation
  security.protectKernelImage = lib.mkForce false;
  boot.resumeDevice = "/dev/mapper/nixos";
  boot.kernelParams = [ "nosgx" ] ++ [ "resume_offset=533760" ];

  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.timeout = 0;

  # Zram
  zramSwap.enable = true;

  # Enable TRIM
  services.fstrim.enable = true;

  users.mutableUsers = false;

  age.secrets.userHashedPassword.file = ./secrets/userHashedPassword.age;
  users.users.${username}.hashedPasswordFile = config.age.secrets.userHashedPassword.path;
  users.users.root.hashedPasswordFile = config.age.secrets.userHashedPassword.path;

  system.stateVersion = "24.05";
}
