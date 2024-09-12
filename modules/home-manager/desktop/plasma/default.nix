{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.kostek001.desktop.plasma;
in
{
  options.kostek001.desktop.plasma = {
    enable = lib.mkEnableOption "Plasma";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (catppuccin-kde.override { flavour = [ "mocha" ]; accents = [ "blue" ]; })
      (catppuccin.override { variant = "mocha"; accent = "blue"; themeList = [ "kvantum" ]; })
      (afterglow-cursors-recolored.override { themeVariants = [ "Catppuccin" ]; catppuccinColorVariants = [ "Macchiato" ]; })
      (catppuccin-papirus-folders.override { flavor = "mocha"; accent = "blue"; })

      inputs.kostek001-pkgs.packages.${pkgs.system}.kde-material-you-colors
      inputs.kostek001-pkgs.packages.${pkgs.system}.kde-material-you-colors.widget
    ];

    xdg.dataFile."plasma-manager/wallpapers".source = ../../../../resources/wallpapers;

    programs.plasma = {
      enable = true;
      overrideConfig = true;

      workspace = {
        clickItemTo = "select";

        theme = "default";
        colorScheme = "CatppuccinMochaBlue";
        cursor.theme = "Afterglow-Recolored-Catppuccin-Macchiato";
        iconTheme = "Papirus-Dark";
        windowDecorations = {
          library = "org.kde.breeze";
          theme = "Breeze";
        };
        splashScreen.theme = "None";

        wallpaper = "${config.xdg.dataHome}/plasma-manager/wallpapers/main.jpeg";
      };

      input.keyboard.layouts = [
        { layout = "pl"; }
      ];

      panels = [
        {
          location = "top";
          height = 40;
          widgets = [
            {
              name = "org.kde.plasma.kickoff";
              config = {
                General = {
                  icon = "pop-cosmic-applications";
                  showActionButtonCaptions = false;
                  alphaSort = true;
                };
              };
            }
            "org.kde.plasma.panelspacer"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General = {
                  groupedTaskVisualization = 2;
                  launchers = [
                    "applications:firefox-beta.desktop"
                    "preferred://filemanager"
                    "applications:org.kde.konsole.desktop"
                    "applications:steam.desktop"
                    "applications:org.prismlauncher.PrismLauncher.desktop"
                    "applications:codium-url-handler.desktop"
                    "applications:vesktop.desktop"
                  ];
                };
              };
            }
            "org.kde.plasma.panelspacer"
            {
              systemTray.items = {
                configs.battery.showPercentage = true;
              };
            }
            {
              name = "org.kde.plasma.digitalclock";
              config = {
                Appearance = {
                  showDate = false;
                  # Font
                  autoFontAndSize = false;
                  fontFamily = "FreeMono";
                  fontWeight = 700;
                  boldText = true;
                  fontSize = 36;
                };
              };
            }
          ];
          floating = true;
          screen = 0;
        }
      ];

      kwin = {
        titlebarButtons = {
          left = [ ];
          right = [ "help" "minimize" "maximize" "close" ];
        };
        effects = {
          shakeCursor.enable = false;
        };
        virtualDesktops = {
          rows = 1;
          number = 4;
        };

        edgeBarrier = 50;
        cornerBarrier = true;
      };

      powerdevil = {
        AC = {
          autoSuspend.action = "nothing";
          turnOffDisplay = {
            idleTimeout = 300;
            idleTimeoutWhenLocked = 20;
          };
          dimDisplay.enable = false;
        };
        battery = {
          turnOffDisplay = config.programs.plasma.powerdevil.AC.turnOffDisplay;
          whenSleepingEnter = "standbyThenHibernate";
        };
        lowBattery = { };
      };

      shortcuts = {
        "services/org.kde.konsole.desktop"."_launch" = "Meta+T";
        kwin = {
          "Switch to Desktop 1" = "Meta+F1";
          "Switch to Desktop 2" = "Meta+F2";
          "Switch to Desktop 3" = "Meta+F3";
          "Switch to Desktop 4" = "Meta+F4";
        };
      };

      kscreenlocker = {
        autoLock = true;
        lockOnResume = true;
        passwordRequiredDelay = 5;
        appearance = {
          wallpaper = "${config.xdg.dataHome}/plasma-manager/wallpapers/lockscreen.gif";
        };
      };

      configFile = {
        kdeglobals."KFileDialog Settings" = {
          "Allow Expansion" = false;
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Decoration position" = 2;
          "LocationCombo Completionmode" = 5;
          "PathCombo Completionmode" = 5;
          "Show Bookmarks" = false;
          "Show Full Path" = false;
          "Show Inline Previews" = true;
          "Show Preview" = false;
          "Show Speedbar" = true;
          "Show hidden files" = false;
          "Sort by" = "Name";
          "Sort directories first" = true;
          "Sort hidden files last" = false;
          "Sort reversed" = false;
          "Speedbar Width" = 250;
          "View Style" = "DetailTree";
        };

        # Wallpaper fix
        plasmarc.Wallpapers."usersWallpapers" = builtins.toString ../../../../resources/background-2.jpeg;

        # Disable plasma-browser-integration notification
        kded5rc.Module-browserintegrationreminder.autoload = false;
      };

      # startup.desktopScript."panels_and_wallpaper".text = config.programs.plasma.startup.desktopScript."panels_and_wallpaper".text + ''
      #   // Disable icons
      #   let allDesktops = desktops();
      #   for (const desktop of allDesktops) {
      #     desktop.plugin = "org.kde.desktopcontainment";
      #   }
      # '';
    };
  };
}
