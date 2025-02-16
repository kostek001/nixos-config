{ config, ... }:

{
  imports = [
    (import ../../users/robol { username = "robol"; fullname = "Robol"; })
  ];

  users.mutableUsers = false;
  # root
  users.users.root.password = "dupa";
  # age.secrets.rootHashedPassword.file = ./secrets/rootHashedPassword.age;
  # users.users.root.hashedPasswordFile = config.age.secrets.rootHashedPassword.path;
  # robol
  age.secrets.robolHashedPassword.file = ./secrets/robolHashedPassword.age;
  users.users.robol.hashedPasswordFile = config.age.secrets.robolHashedPassword.path;
  # olek
  age.secrets.olekHashedPassword.file = ./secrets/olekHashedPassword.age;
  users.users.olek = {
    isNormalUser = true;
    description = "Olek";
    hashedPasswordFile = config.age.secrets.olekHashedPassword.path;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "robol";
  };
}
