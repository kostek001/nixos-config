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
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.plasma-browser-integration
    ];

    programs.dconf.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland,x11";
      # XWAYLAND_NO_GLAMOR = "1";
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}