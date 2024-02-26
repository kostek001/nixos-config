{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.desktop.plasma;
in
{
  options.kostek001.desktop.plasma = {
    enable = mkEnableOption "KDE Plasma";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.plasma5.enable = true;

    environment.systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.plasma-browser-integration
    ];

    programs.dconf.enable = true;
  };
}