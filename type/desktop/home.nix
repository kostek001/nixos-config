{ ... }:

{
  home.stateVersion = "23.11";

  imports = [
    ../../modules/home-manager
  ];

  programs.git.enable = true;

  kostek001.games.minecraft.enable = true;
  kostek001.games.vr.enable = true;
  kostek001.programs.obs.enable = true;

  kostek001.desktop.plasma.enable = true;

  services.arrpc.enable = true;
}
