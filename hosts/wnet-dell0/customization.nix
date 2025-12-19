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

  # User password hashes # TODO: persist /etc/shadow
  systemd.tmpfiles.rules = [ "d /nix/persist/var/lib/shadow 0600 root root - -" ];
  users.users.robol.hashedPasswordFile = "/nix/persist/var/lib/shadow/robol.hashed-password";

  services.openssh.enable = true;
  knix.boot.plymouth.enable = false;
}
