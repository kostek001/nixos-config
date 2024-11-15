{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.khome.games.minecraft;
in
{
  options.khome.games.minecraft = {
    enable = mkEnableOption "Minecraft";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [ jdk8 jdk17 jdk21 ];
      })
    ];

    # Fix audio
    home.file.".alsoftrc".text = ''
      [general]
      drivers = pulse

      [pulse]
      allow-moves=yes
    '';
  };
}
