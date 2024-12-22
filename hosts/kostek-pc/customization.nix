{ ... }:

{
  imports = [
    (import ../../users/kostek/default.nix { username = "kostek"; fullname = "Kostek"; })
  ];
  knix.users.kostek.autologin.enable = true;
  knix.users.kostek.pentesting.enable = true;

  knix.misc.virtualisation.enable = true;
  knix.users.kostek.vr.enable = true;

  home-manager.users.kostek = { ... }: {
    khome.games.vr.enable = true;
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
