{ username, fullname }: { ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = fullname;
    extraGroups = [ "networkmanager" ];
  };

  home-manager.users.${username} = import ./home;
}
