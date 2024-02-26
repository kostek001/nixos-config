{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.hardware.hid;
in
{
  options.kostek001.hardware.hid = {
    enable = mkEnableOption "HID Devices";
  };

  config = mkIf cfg.enable {
    # Many keyboard, mouses
    services.ratbagd.enable = true;

    # QMK Keyboards
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      piper
      via
    ];
  };
}
