{ config, pkgs, ... }:

{
  imports = [
    (import ../../users/robol { username = "robol"; fullname = "Robol"; })
  ];

  services.openssh.enable = true;

  users.mutableUsers = true;
  # root
  age.secrets.rootHashedPassword.file = ./secrets/rootHashedPassword.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootHashedPassword.path;
  users.users.root.openssh.authorizedKeys.keys = (import ../identities.nix).masterKeys;
  # robol
  age.secrets.robolHashedPassword.file = ./secrets/robolHashedPassword.age;
  users.users.robol.hashedPasswordFile = config.age.secrets.robolHashedPassword.path;

  services.displayManager.autoLogin = {
    enable = true;
    user = "robol";
  };

  knix.misc.printing.enable = true;

  # Allow Minecraft port
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
