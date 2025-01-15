{ cfg }: { lib, pkgs, ... }:
with lib;

{
  config = mkIf cfg.enable (
    let
      enabledExtensions = with pkgs.gnomeExtensions; [
        gsconnect
        blur-my-shell
        appindicator
        just-perfection
        unblank
        pip-on-top
      ];

      extensions = enabledExtensions ++ (with pkgs.gnomeExtensions; [
        burn-my-windows
        wallpaper-slideshow
        media-controls
        quick-settings-audio-devices-hider
      ]);
    in
    {
      programs.dconf = {
        enable = true;
        profiles.user.databases = [{
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
            };
            "org/gnome/shell" = {
              disable-user-extensions = false;
              enabled-extensions = builtins.map (x: x.extensionUuid) enabledExtensions;
            };
            "org/gnome/shell/extensions/unblank" = {
              power = false;
              time = gvariant.mkInt32 30;
            };

            "org/gnome/desktop/wm/keybindings" = {
              switch-applications = gvariant.mkEmptyArray (gvariant.type.string);
              switch-applications-backward = gvariant.mkEmptyArray (gvariant.type.string);
              switch-windows = [ "<Super>Tab" "<Alt>Tab" ];
              switch-windows-backward = [ "<Shift><Super>Tab" "<Shift><Alt>Tab" ];
            };
          };
        }];
      };

      environment.systemPackages = extensions ++ (with pkgs; [
        adw-gtk3
        bibata-cursors
      ]);

      qt = {
        enable = true;
        style = "adwaita";
        platformTheme = "gnome";
      };

      # Allow GSConnect connections
      networking.firewall = rec {
        allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    }
  );
}
