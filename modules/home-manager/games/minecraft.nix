{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.games.minecraft;
in
{
  options.kostek001.games.minecraft = {
    enable = mkEnableOption "Minecraft";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [ jdk8 jdk17 jdk21 ];
        withWaylandGLFW = true;
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
