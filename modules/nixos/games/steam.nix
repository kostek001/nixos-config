{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.games.steam;
in
{
  options.kostek001.games.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}
