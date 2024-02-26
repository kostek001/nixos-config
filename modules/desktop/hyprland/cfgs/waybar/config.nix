lib: pkgs:
{
  mainBar = {
    layer = "top";
    position = "top";

    height = 30;
    spacing = 15;
    margin-top = 10;
    margin-left = 10;
    margin-right = 10;

    modules-left = [ "hyprland/workspaces" "wlr/taskbar" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "tray" "pulseaudio" "privacy" "temperature" "clock" ];

    "wlr/taskbar" = {
      icon-size = 20;
      on-click = "minimize-raise";
      on-right-click = "fullscreen";
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      format-icons = {
        "active" = "";
        "default" = "";
      };
      all-outputs = false;
      persistent-workspaces = {
        "DP-2" = [ 1 2 3 4 5 ];
        "DP-1" = [ 6 7 8 9 10 ];
      };
      # persistent_workspaces = lib.mkMerge (builtins.genList (x: { "${builtins.toString (x + 1)}" = [ ]; }) 10);
    };

    pulseaudio = {
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-muted = "󰝟";
      format-icons = {
        hdmi = "󰽟";
        headphone = "󰋋";
        headset = "󰋎";
        phone = "";
        speaker = "󰓃";
        default = "󰓃";
      };
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
    };

    tray = {
      icon-size = 20;
      spacing = 10;
    };
  };
}
