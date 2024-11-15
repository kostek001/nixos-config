{ username, fullname }: { config, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = fullname;
    extraGroups = [ "wheel" ] ++ config.knix.privileged.groups;
  };

  imports = [ (import ./nixos { inherit username; }) ];
  home-manager.users.${username} = import ./home;
}
