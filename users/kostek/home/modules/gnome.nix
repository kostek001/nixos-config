{ config, lib, ... }:
with lib;

let
  cfg = config.khome.gnome;
in
{
  options.khome.gnome = {
    enable = mkEnableOption "Gnome";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      # Open terminal on SUPER+T
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "Terminal";
      };

      # Workspaces
      "org/gnome/mutter".workspaces-only-on-primary = false;
      "org/gnome/mutter".dynamic-workspaces = false;
      "org/gnome/desktop/wm/preferences".num-workspaces = gvariant.mkInt32 8;
      "org/gnome/shell/app-switcher".current-workspace-only = true;
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = [ "<Super>F1" ];
        switch-to-workspace-2 = [ "<Super>F2" ];
        switch-to-workspace-3 = [ "<Super>F3" ];
        switch-to-workspace-4 = [ "<Super>F4" ];
        switch-to-workspace-5 = [ "<Super>1" ];
        switch-to-workspace-6 = [ "<Super>2" ];
        switch-to-workspace-7 = [ "<Super>3" ];
        switch-to-workspace-8 = [ "<Super>4" ];

        move-to-workspace-1 = [ "<Shift><Super>F1" ];
        move-to-workspace-2 = [ "<Shift><Super>F2" ];
        move-to-workspace-3 = [ "<Shift><Super>F3" ];
        move-to-workspace-4 = [ "<Shift><Super>F4" ];
        move-to-workspace-5 = [ "<Shift><Super>1" ];
        move-to-workspace-6 = [ "<Shift><Super>2" ];
        move-to-workspace-7 = [ "<Shift><Super>3" ];
        move-to-workspace-8 = [ "<Shift><Super>4" ];
      };
      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = gvariant.mkEmptyArray (gvariant.type.string);
        switch-to-application-2 = gvariant.mkEmptyArray (gvariant.type.string);
        switch-to-application-3 = gvariant.mkEmptyArray (gvariant.type.string);
        switch-to-application-4 = gvariant.mkEmptyArray (gvariant.type.string);
      };

      # Look
      "org/gnome/desktop/interface" = {
        accent-color = "purple";
        color-scheme = "prefer-dark";
        # Fonts
        document-font-name = "Cantarell 11";
        font-name = "Cantarell 11";
        monospace-font-name = "Source Code Pro 11";
      };
      "org/gnome/shell/extensions/just-perfection" = {
        support-notifier-type = gvariant.mkInt32 0;
        workspace-popup = false;
        window-demands-attention-focus = true;
        ripple-box = false;
        quick-settings-dark-mode = false;
        # 
        startup-status = gvariant.mkInt32 0; # Show desktop after startup
        show-apps-button = false; # Hide all apps button in dash
        workspace-wrap-around = true;
        weather = false; # Disable weather in clock menu
      };
    };
  };
}
