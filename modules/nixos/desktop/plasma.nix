{ config, lib, pkgs, inputs, ... }:
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

    environment.plasma6.excludePackages = with pkgs.kdePackages; [ kate ];

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
      kdePackages.partitionmanager
      
      # inputs.kostek001-pkgs.packages.${system}.plasma-smart-video-wallpaper-reborn
      # qt6.qtmultimedia

      inputs.kostek001-pkgs.packages.${system}.wallpaper-engine-kde-plugin
      qt6.qtwebsockets
    ];

    programs.kdeconnect.enable = true;


    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # Fix for Xwayland Nvidia, breaks games
      # XWAYLAND_NO_GLAMOR = "1";
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    # For KDE + GNOME
    # programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  };
}