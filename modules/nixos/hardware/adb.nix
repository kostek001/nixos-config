{ config, lib, username, ... }:
with lib;

let
  cfg = config.kostek001.hardware.adb;
in
{
  options.kostek001.hardware.adb = {
    enable = mkEnableOption "ADB";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${username}.extraGroups = [ "adbusers" ];
  };
}
