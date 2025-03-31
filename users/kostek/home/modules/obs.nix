{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.khome.obs;
in
{
  options.khome.obs = {
    enable = mkEnableOption "OBS Studio";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = (with pkgs.obs-studio-plugins; [
        waveform
        obs-tuna
        obs-vkcapture
        obs-move-transition
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ]);
    };
  };
}
