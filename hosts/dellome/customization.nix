{ config, pkgs, ... }:

{
  imports = [
    (import ../../users/kostek/default.nix { username = "kostek"; fullname = "Kostek"; })
  ];
  knix.users.kostek.autologin.enable = true;
  knix.users.kostek.pentesting.enable = true;

  ## USERS
  users.mutableUsers = false;
  age.secrets.userHashedPassword.file = ./secrets/userHashedPassword.age;
  users.users.root.hashedPasswordFile = config.age.secrets.userHashedPassword.path;
  users.users.kostek.hashedPasswordFile = config.age.secrets.userHashedPassword.path;

  home-manager.users.kostek = { ... }: {
    home.packages = with pkgs; [ mixxx ];
  };

  # Podman
  virtualisation.podman.enable = true;
  environment.systemPackages = with pkgs; [ podman-tui podman-compose ];
  virtualisation.containers.containersConf.settings = {
    network = {
      default_subnet = "172.17.0.0/16";
      default_subnet_pools = [
        { base = "172.18.0.0/16"; size = 24; }
      ];
    };
  };

  services.zerotierone.enable = true;
  environment.persistence."/persistence".directories = [ "/var/lib/zerotier-one" ];

  knix.boot.plymouth.enable = false;

  programs.git.config = {
    safe.directory = "/etc/nixos";
  };
}
