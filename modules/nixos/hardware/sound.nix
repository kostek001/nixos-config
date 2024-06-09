{ config, lib, ... }:
with lib;

let
  cfg = config.kostek001.hardware.sound;
in
{
  options.kostek001.hardware.sound = {
    enable = mkEnableOption "Sound";
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };
  };
}