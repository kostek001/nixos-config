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
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      elisa
      khelpcenter
    ];

    environment.systemPackages = with pkgs; [
      # Previews for .webp, .tiff, .tga, .jp2 files
      kdePackages.qtimageformats

      # inputs.kostek001-pkgs.packages.${system}.wallpaper-engine-kde-plugin
      # qt6.qtwebsockets
      # qt6.qtmultimedia
    ];

    programs.partition-manager.enable = true;

    programs.kdeconnect.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
