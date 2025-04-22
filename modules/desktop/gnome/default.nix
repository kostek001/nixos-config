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
      geary # Mail reader
      evince # Document viewer
    ];

    services.gnome.core-utilities.enable = false;
    environment.systemPackages = with pkgs; [
      baobab # Analyse disk usage
      # epiphany # Web browser
      # gnome-text-editor
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-console
      gnome-contacts
      # gnome-font-viewer # font-manager better
      gnome-logs
      # gnome-maps
      gnome-music
      gnome-system-monitor
      # gnome-weather
      loupe # Image viewer
      nautilus # File manager
      gnome-connections # Remote desktop
      # simple-scan # Scan app
      # snapshot # Camera app
      # totem # Video player
      # yelp # Help viewer
    ] ++ [
      gnome-tweaks
      pwvucontrol # Better audio settings
      mission-center # Better system monitor
    ];

    programs.evince.enable = true; # Document viewer
    programs.file-roller.enable = true; # View, modify archives
    programs.gnome-disks.enable = true; # Manage disks and partitions
    programs.seahorse.enable = true; # Manage keys and passwords

    # VTE shell integration for gnome-console
    programs.bash.vteIntegration = mkDefault true;
    programs.zsh.vteIntegration = mkDefault true;
  };
}
