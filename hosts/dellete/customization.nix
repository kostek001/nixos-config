{ config, ... }:

{
  imports = [
    (import ../../users/robol { username = "robol"; fullname = "Robol"; })
  ];

  services.openssh.enable = true;

  users.mutableUsers = false;
  # root
  age.secrets.rootHashedPassword.file = ./secrets/rootHashedPassword.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootHashedPassword.path;
  users.users.root.openssh.authorizedKeys.keys = (import ../identities.nix).masterKeys;
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
