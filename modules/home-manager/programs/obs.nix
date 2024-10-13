{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.programs.obs;
in
{
  options.kostek001.programs.obs = {
    enable = mkEnableOption "OBS Studio";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = (with pkgs.obs-studio-plugins; [
        droidcam-obs
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
