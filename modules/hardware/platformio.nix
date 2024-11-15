{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.knix.hardware.platformio;
in
{
  options.knix.hardware.platformio = {
    enable = mkEnableOption "PlatformIO";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      pkgs.platformio
      pkgs.openocd
    ];

    knix.privileged.groups = [ "dialout" ];
  };
}
