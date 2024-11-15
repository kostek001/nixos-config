{ config, username, ... }:

{
  # TODO: replace with hardcoded username
  users.users.${username} = {
    isNormalUser = true;
    description = "Kostek";
    extraGroups = [ "wheel" ] ++ config.knix.privileged.groups;
  };

  imports = [ ./nixos ];
  home-manager.users.${username} = import ./home;
}
