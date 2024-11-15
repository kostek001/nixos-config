{ ... }:

{
  imports = [
    ../../users/kostek/default.nix
  ];
  knix.users.kostek.autologin.enable = true;

  knix.misc.virtualisation.enable = true;
  knix.users.kostek.vr.enable = true;

  home-manager.users.kostek = { ... }: {
    khome.games.vr.enable = true;
  };
}
