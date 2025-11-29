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
    copyMonitorsXml = {
      enable = mkEnableOption "Copy monitors.xml";
      path = mkOption {
        type = types.path;
        default = "/usr/gnome/monitors.xml";
        description = "Path for storing global monitors.xml";
      };
    };
  };

  imports = [
    (import ./copy-monitors-xml.nix { inherit cfg; })
    (import ./gdm.nix { inherit cfg; })
    (import ./remote-desktop.nix { inherit cfg; })
    (import ./settings.nix { inherit cfg; })
  ];

  config = mkIf cfg.enable {
    # Enable GDM by default
    knix.desktop.gnome.gdm.enable = mkDefault true;

    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      geary # Mail reader (replaced with thunderbird)
    ];

    # TODO: replace with core-apps.enable on 25.11
    services.gnome.core-apps.enable = false;
    environment.systemPackages = with pkgs; [
      baobab # Analyse disk usage
      decibels # Music player
      # epiphany # Web browser
      gnome-text-editor # Simple text editor
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-console
      gnome-contacts
      gnome-font-viewer # font-manager is better
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      loupe # Image viewer
      nautilus # File manager
      papers # Document viewer (replaces evince)
      gnome-connections # Remote desktop
      showtime # Video player (replaces totem)
      simple-scan # Scan app
      snapshot # Camera app
      # yelp # Help viewer
    ] ++ [
      gnome-tweaks
      pwvucontrol # Better audio settings
      mission-center # Better system monitor
      # celluloid # Better video player
    ];

    programs.file-roller.enable = true; # View, modify archives
    programs.gnome-disks.enable = true; # Manage disks and partitions
    programs.seahorse.enable = true; # Manage keys and passwords

    # VTE shell integration for gnome-console
    programs.bash.vteIntegration = mkDefault true;
    programs.zsh.vteIntegration = mkDefault true;

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
