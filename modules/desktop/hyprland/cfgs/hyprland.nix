pkgs:

let
  closeOnUnfocus = pkgs.writeScript "closeOnUnfocus" ''
    #!/usr/bin/env bash
    $@ <&0 & app_pid=$!
    sleep 0.3
    while [ $(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq ".pid") == $app_pid ]; do sleep 0.2; done
    kill $app_pid & exit 0
  '';
  hyprwork = pkgs.writeShellApplication {
    name = "hyprwork";
    runtimeInputs = with pkgs; [ hyprland gnused ];
    checkPhase = false;
    text = ''
      #!/usr/bin/env bash
      if [[ $1 =~ ^(workspace|movetoworkspace|movetoworkspacesilent)$ ]]; then
        activeMonitor=$(hyprctl activeworkspace -j | sed -n 's/\s*"monitor": "\(.*\)",/\1/p')
        workspaces=($(sed -n "s/workspace=\([0-9]\+\),\s*monitor:$activeMonitor\(,.*\)\?/\1/p" ~/.config/hypr/hyprland.conf))
        hyprctl dispatch "$1" "''${workspaces[$(($2 - 1))]}"
      else
        echo "Usage: hyprwork <MODE> <WORKSPACE_NUMBER>"
        echo
        echo "Modes: workspace, movetoworkspace, movetoworkspacesilent"
      fi
    '';
  };
in
{
  monitor = [
    "desc:Acer Technologies XF250Q TA1EE0128554,highrr,0x0,1"
    "desc:HP Inc. HP X24ih 1CR232079G,highrr,auto,1"
    # Mirror
    ",preferred,auto,1,mirror,desc:Acer Technologies XF250Q TA1EE0128554"
  ];

  exec-once = [
    "${pkgs.hyprpaper}/bin/hyprpaper"
    "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
    "${pkgs.waybar}/bin/waybar"
    "${pkgs.dunst}/bin/dunst"
  ];

  # Programs
  "$terminal" = "${pkgs.kitty}/bin/kitty";
  "$fileManager" = "${pkgs.dolphin}/bin/dolphin";
  "$menu" = "${pkgs.wofi}/bin/wofi";

  env = [
    "NIXOS_OZONE_WL,1"
    #"QT_QPA_PLATFORMTHEME,gtk3"

    "WLR_NO_HARDWARE_CURSORS,1"
    "WLR_DRM_NO_ATOMIC,1" # Allow tearing
  ];

  input = {
    kb_layout = "pl";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";

    follow_mouse = 2;
    touchpad = {
      natural_scroll = false;
    };

    sensitivity = 0;
  };

  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";

    layout = "dwindle";

    allow_tearing = true;
  };

  decoration = {
    rounding = 10;

    blur = {
      enabled = true;
      size = 3;
      passes = 1;
    };

    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };

  animations = {
    enabled = true;

    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true; # you probably want this
  };

  master = {
    new_is_master = true;
  };

  misc = {
    force_default_wallpaper = 0;
  };

  workspace = [
    "1, monitor:DP-2, default:true"
    "2, monitor:DP-2"
    "3, monitor:DP-2"
    "4, monitor:DP-2"
    "5, monitor:DP-2"
    "6, monitor:DP-1, default:true"
    "7, monitor:DP-1"
    "8, monitor:DP-1"
    "9, monitor:DP-1"
    "10, monitor:DP-1"
  ];

  "$mainMod" = "SUPER";

  bind = [
    "$mainMod, T, exec, $terminal"
    "$mainMod, Q, killactive,"
    "$mainMod, M, exec, ${pkgs.nwg-bar}/bin/nwg-bar"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, F, togglefloating,"
    "$mainMod, R, exec, ${closeOnUnfocus} $menu --show drun -I"
    "$mainMod, P, pseudo,"
    "$mainMod, J, togglesplit,"
    "$mainMod, L, exec, ${pkgs.systemd}/bin/loginctl lock-session"

    # Print screen
    "$mainMod, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m window"
    ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"

    # Move focus with mainMod + arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    # ] ++ (
    #   # workspaces
    #   # binds $mod + [shift +] {0..9} to [move to] workspace {1..10}
    #   builtins.concatLists (builtins.genList
    #     (
    #       x:
    #       let
    #         ws =
    #           let
    #             c = (x + 1) / 10;
    #           in
    #           builtins.toString (x + 1 - (c * 10));
    #       in
    #       [
    #         "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
    #         "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    #       ]
    #     )
    #     10)
    # ) ++ [
    # Example special workspace (scratchpad)
    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"

    # Scroll through existing workspaces with mainMod + scroll
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    # Clipboard history
    "$mainMod, V, exec, ${pkgs.cliphist}/bin/cliphist list | ${closeOnUnfocus} $menu --dmenu -I | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
  ] ++ [
    # Volume and Media Control
    ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
    ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
    ", XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -m"
    ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
    ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
    ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
    ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
    ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
  ] ++ [
    "$mainMod, 1, exec, ${hyprwork}/bin/hyprwork workspace 1"
    "$mainMod, 2, exec, ${hyprwork}/bin/hyprwork workspace 2"
    "$mainMod, 3, exec, ${hyprwork}/bin/hyprwork workspace 3"
    "$mainMod, 4, exec, ${hyprwork}/bin/hyprwork workspace 4"
    "$mainMod, 5, exec, ${hyprwork}/bin/hyprwork workspace 5"

    "$mainMod SHIFT, 1, exec, ${hyprwork}/bin/hyprwork movetoworkspace 1"
    "$mainMod SHIFT, 2, exec, ${hyprwork}/bin/hyprwork movetoworkspace 2"
    "$mainMod SHIFT, 3, exec, ${hyprwork}/bin/hyprwork movetoworkspace 3"
    "$mainMod SHIFT, 4, exec, ${hyprwork}/bin/hyprwork movetoworkspace 4"
    "$mainMod SHIFT, 5, exec, ${hyprwork}/bin/hyprwork movetoworkspace 5"
  ];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  windowrule = [
    "idleinhibit fullscreen,.*"
  ];

  layerrule = [
    "blur, waybar"
  ];
}
