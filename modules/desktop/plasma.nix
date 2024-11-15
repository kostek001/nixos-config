{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.knix.desktop.plasma;
in
{
  options.knix.desktop.plasma = {
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

      kdePackages.filelight # Disk utilization

      # For Ark
      p7zip
      unar
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
