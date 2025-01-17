{ config, ... }:

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

  # Enable docker
  virtualisation.docker.enable = true;
  users.users.kostek.extraGroups = [ "docker" ];

  services.zerotierone.enable = true;
  environment.persistence."/persistence".directories = [ "/var/lib/zerotier-one" ];

  knix.boot.plymouth.enable = false;

  programs.git.config = {
    safe.directory = "/etc/nixos";
  };
}
