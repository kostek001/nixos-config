{ cfg }: { lib, pkgs, ... }:
with lib;

{
  config = mkIf cfg.enable (
    let
      enabledExtensions = with pkgs.gnomeExtensions; [
        gsconnect # KDE Connect for GNOME
        appindicator # Tray icons
        blur-my-shell
        just-perfection
        unblank
        pip-on-top
      ];

      extensions = enabledExtensions ++ (with pkgs.gnomeExtensions; [
        burn-my-windows
        wallpaper-slideshow
        mpris-label # Replaces `media-controls`
        quick-settings-audio-devices-hider
        tiling-assistant
      ]);
    in
    {
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            lockAll = false;
            settings = {
              "org/gnome/desktop/interface" = {
                clock-show-weekday = true;
                gtk-theme = "adw-gtk3";
                cursor-theme = "Bibata-Modern-Classic";
                color-scheme = "prefer-dark";
              };
              "org/gnome/desktop/wm/preferences" = {
                button-layout = "appmenu:minimize,maximize,close";
                resize-with-right-button = true;
              };
              "org/gnome/mutter" = {
                edge-tiling = true;
                workspaces-only-on-primary = false;
              };

              # TODO: remove or apply
              # "org/gnome/desktop/wm/keybindings" = {
              #   switch-applications = gvariant.mkEmptyArray (gvariant.type.string);
              #   switch-applications-backward = gvariant.mkEmptyArray (gvariant.type.string);
              #   switch-windows = [ "<Super>Tab" "<Alt>Tab" ];
              #   switch-windows-backward = [ "<Shift><Super>Tab" "<Shift><Alt>Tab" ];
              # };

              # Extensions
              "org/gnome/shell" = {
                disable-user-extensions = false;
                enabled-extensions = builtins.map (x: x.extensionUuid) enabledExtensions;
              };
              "org/gnome/shell/extensions/unblank" = {
                power = false;
                time = gvariant.mkInt32 30;
              };
              "org/gnome/shell/extensions/just-perfection" = {
                support-notifier-type = gvariant.mkInt32 0;
                workspace-popup = false; # Disable popup on workspace change
                window-demands-attention-focus = true;
                ripple-box = false; # Disable hot corner animation
                quick-settings-dark-mode = false;
              };
            };
          }
          {
            lockAll = true;
            settings = {
              "org/gnome/shell" = {
                allow-extension-installation = false;
                development-tools = false; # Disable ALT+F2 debug dialog
              };
            };
          }
        ];

        # For GDM display manager
        profiles.gdm.databases = [{
          settings = {
            "org/gnome/desktop/interface".cursor-theme = "Bibata-Modern-Classic";
          };
        }];
      };

      environment.systemPackages = extensions ++ (with pkgs; [
        adw-gtk3 # Adwaita theme for GTK3
        bibata-cursors
      ]);

      # Old fonts (from GNOME <48)
      fonts.packages = with pkgs; [
        cantarell-fonts
        source-code-pro
      ];

      # Adwaita-like theme for QT
      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      # Allow GSConnect connections
      networking.firewall = rec {
        allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    }
  );
}
