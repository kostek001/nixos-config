{ ... }:

{
  imports = [
    (import ../../users/robol { username = "robol"; fullname = "Robol"; })
  ];

  users.mutableUsers = false;
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    password = "dupa";
  };
}
