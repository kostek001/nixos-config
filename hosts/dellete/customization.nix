{ config, pkgs, ... }:

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
  # user0
  age.secrets.user0HashedPassword.file = ./secrets/user0HashedPassword.age;
  users.users.user0 = {
    isNormalUser = true;
    description = "User";
    hashedPasswordFile = config.age.secrets.user0HashedPassword.path;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "robol";
  };

  services.printing = {
    enable = true;
    browsed.enable = false;
    drivers = with pkgs; [
      cups-filters
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
