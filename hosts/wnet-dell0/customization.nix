{ config, ... }:

{
  imports = [
    (import ../../users/robol { username = "robol"; fullname = "Robol"; })
  ];

  ## USERS
  users.mutableUsers = true;
  age.secrets.rootHashedPassword.file = ./secrets/rootHashedPassword.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootHashedPassword.path;
  users.users.root.openssh.authorizedKeys.keys = (import ../identities.nix).masterKeys;

  services.openssh.enable = true;
  knix.boot.plymouth.enable = false;
}
