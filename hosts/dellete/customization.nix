{ ... }:

{
  imports = [
    (import ../../users/robol { username = "robol"; fullname = "Robol"; })
  ];

  users.mutableUsers = false;
  users.users.robol.passwordFile = "/persist/users/robol.pass";
  users.users.root.password = "dupa";
}
