{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.desktop.gnome;
in
{
  options.kostek001.desktop.gnome = {
    enable = mkEnableOption "Gnome";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };
}