{ username, fullname }: { ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = fullname;
    extraGroups = [ "networkmanager" ];
  };
}
