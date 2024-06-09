{ config, lib, pkgs, username, ... }:
with lib;

let
  cfg = config.kostek001.hardware.platformio;
in
{
  options.kostek001.hardware.platformio = {
    enable = mkEnableOption "PlatformIO";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      pkgs.platformio
      pkgs.openocd
    ];

    users.users.${username}.extraGroups = [ "dialout" ];
  };
}
