{ config, lib, pkgs, username, ... }:
with lib;

let
  cfg = config.kostek001.desktop.hyprland;
in
{
  options.kostek001.desktop.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      #xdgOpenUsePortal = true; # breaks steam://
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    programs.dconf.enable = true;

    security.pam.services.swaylock = { };

    # fix this and others
    #kostek001.services.swayosd-backend.enable = true;

    home-manager.users.${username} = { config, ... }:
      {
        home.packages = with pkgs; [
          cliphist
          hyprpicker
          #hyprshot
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          settings = import cfgs/hyprland.nix pkgs;
        };

        programs.wofi = {
          enable = true;
          settings = import cfgs/wofi/config.nix;
          style = builtins.readFile cfgs/wofi/style.css;
        };

        programs.waybar = {
          enable = true;
          settings = import cfgs/waybar/config.nix lib pkgs;
          style = builtins.readFile cfgs/waybar/style.css;
        };

        programs.swaylock = {
          enable = true;
          package = pkgs.swaylock-effects;
          settings = import cfgs/swaylock.nix;
        };

        kostek001.programs.dunst = {
          enable = true;
          settings = import cfgs/dunst.nix;
        };

        xdg.configFile."hypr/hyprpaper.conf".text = import cfgs/hyprpaper.nix;

        kostek001.services.cliphist = {
          enable = true;
          systemdTarget = "hyprland-session.target";
          settings = {
            maxDedupeSearch = 30;
            maxItems = 30;
          };
        };

        kostek001.services.swayidle = {
          enable = true;
          systemdTarget = "hyprland-session.target";
          events = [
            {
              event = "lock";
              command = "${config.programs.swaylock.package}/bin/swaylock -f";
            }
            {
              event = "unlock";
              command = "${pkgs.procps}/bin/pkill -SIGUSR1 swaylock";
            }
          ];
          timeouts = [
            {
              timeout = 480;
              command = "${pkgs.systemd}/bin/loginctl lock-session";
            }
            {
              timeout = 20;
              command = "if ${pkgs.procps}/bin/pgrep swaylock; then ${pkgs.hyprland}/bin/hyprctl dispatch dpms off; fi";
              resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            }
          ];
        };

        kostek001.services.wl-clip-persist = {
          enable = true;
          systemdTarget = "hyprland-session.target";
          settings.args = "--read-timeout 50 --write-timeout 1000";
        };

        kostek001.services.swayosd = {
          enable = true;
          systemdTarget = "hyprland-session.target";
        };

        home.pointerCursor = {
          gtk.enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 10;
        };

        qt = {
          enable = true;
          platformTheme = "gtk";
          style.name = "gtk2";
        };

        gtk = {
          enable = true;
          theme = {
            package = pkgs.fluent-gtk-theme.override {
              themeVariants = [ "all" ];
            };
            name = "Fluent-purple-Dark";
          };
          iconTheme = {
            package = pkgs.beauty-line-icon-theme;
            name = "BeautyLine";
          };
          font = {
            package = pkgs.nerdfonts.override { fonts = [ "Noto" ]; };
            name = "NotoSans Nerd Font";
            size = 10;
          };
          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
        };
      };
  };
}
