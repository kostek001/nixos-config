{ cfg }: { lib, pkgs, ... }:
with lib;

{
  config = mkIf cfg.enable (
    let
      extensions = with pkgs.gnomeExtensions; [
        gsconnect
        blur-my-shell
        appindicator
        just-perfection
        unblank
        rounded-window-corners-reborn
      ];
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
            };
            "org/gnome/shell" = {
              disable-user-extensions = false;
              enabled-extensions = builtins.map (x: x.extensionUuid) extensions;
              disabled-extensions = [ "" ];
            };
            "org/gnome/shell/extensions/unblank" = {
              power = false;
              time = gvariant.mkInt32 30;
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
