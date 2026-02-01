{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.knix.desktop.gnome;
in
{
  options.knix.desktop.gnome = {
    enable = mkEnableOption "Gnome";
    gdm.enable = mkEnableOption "GDM";
    remote-desktop.enable = mkEnableOption "Remote Desktop";
    copyMonitors = {
      enable = mkEnableOption "Copy monitors config";
      path = mkOption {
        type = types.path;
        default = "/var/lib/gnome-copy-monitors/monitors.xml";
        description = "Path for storing global monitors.xml";
      };
    };
  };

  imports = [
    (import ./copy-monitors.nix { inherit cfg; })
    (import ./gdm.nix { inherit cfg; })
    (import ./remote-desktop.nix { inherit cfg; })
    (import ./settings.nix { inherit cfg; })
  ];

  config = mkIf cfg.enable {
    # Enable GDM by default
    knix.desktop.gnome.gdm.enable = mkDefault true;

    # Enable GNOME
    services.desktopManager.gnome.enable = true;

    # Apps
    services.gnome.core-apps.enable = true;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany # Web browser (replaced with firefox) 
      geary # Mail reader (replaced with thunderbird)
      yelp # Help viewer
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      pwvucontrol # Better audio settings
      mission-center # Better system monitor
      # celluloid # Better video player
      file-roller
    ];

    # Enable Wayland in apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Temporary fix for Gnome Files audio/video informations
    # https://github.com/NixOS/nixpkgs/issues/53631
    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
      (with pkgs.gst_all_1;[
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
      ]);
  };
}
