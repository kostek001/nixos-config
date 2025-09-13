{ config, ... }:

{
  ## USERS
  users.mutableUsers = false;
  age.secrets.userHashedPassword.file = ./secrets/userHashedPassword.age;
  users.users.root.hashedPasswordFile = config.age.secrets.userHashedPassword.path;
  users.users.serveradmin.hashedPasswordFile = config.age.secrets.userHashedPassword.path;
  users.users.serveradmin.openssh.authorizedKeys.keys = (import ../identities.nix).masterKeys;

  # Allow rebuilding when /etc/nixos isn't owned by root
  programs.git.config.safe.directory = "/etc/nixos";
}
