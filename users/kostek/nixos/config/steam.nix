{ pkgs, ... }:

{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    protonplus
    adwsteamgtk
    mangohud
    mangojuice
  ];
}
