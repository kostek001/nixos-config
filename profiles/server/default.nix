{ config, ... }:

{
  users.users.serveradmin = {
    isNormalUser = true;
    description = "Serveradmin";
    extraGroups = [ "wheel" ] ++ config.knix.privileged.groups;
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
}
