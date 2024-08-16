{ pkgs, inputs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  kostek001.boot.loader.lanzaboote.enable = true;

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

  environment.etc."machine-id".source = "/persistence/etc/machine-id";

  fileSystems."/".options = [ "defaults" "size=25%" "mode=755" ];
  fileSystems."/persistence".neededForBoot = true;

  fileSystems."/home".options = [ "noatime" "compress=zstd" ];
  fileSystems."/nix".options = [ "noatime" "compress=zstd" ];
  fileSystems."/persistence".options = [ "noatime" "compress=zstd" ];

  # Enable TRIM
  boot.initrd.luks.devices."luks-b37a8b13-df13-40d2-893a-791560bc54ce".allowDiscards = true;
  services.fstrim.enable = true;

  users.mutableUsers = false;
  users.users.${username} = {
    password = "dupa";
  };

  system.stateVersion = "24.05";
}

