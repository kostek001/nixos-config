{ ... }:

{
  home.stateVersion = "23.11";

  imports = [
    ../../home
  ];

  programs.git = {
    enable = true;
    userName = "kostek001";
    userEmail = "example@example.net";
  };

  kostek001.games.minecraft.enable = true;
  kostek001.games.vr.enable = true;

  kostek001.desktop.plasma.enable = true;

  services.arrpc.enable = true;
}
