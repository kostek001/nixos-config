{ config, lib, ... }:

let
  cfg = config.kostek001.desktop.plasma;
in
{
  options.kostek001.desktop.plasma = {
    enable = lib.mkEnableOption "Plasma";
  };

  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      powerdevil = {
        autoSuspend.action = "nothing";
        turnOffDisplay.idleTimeoutWhenLocked = 20;
      };

      shortcuts = {
        "services/org.kde.konsole.desktop"."_launch" = "Meta+T";
      };

      configFile = {
        kscreenlockerrc = {
          "Daemon"."Timeout" = 5;
          "Greeter/Wallpaper/org.kde.image/General"."Image" = builtins.toString ../../../../resources/background-3.gif;
          "Greeter/Wallpaper/org.kde.image/General"."PreviewImage" = builtins.toString ../../../../resources/background-3.gif;
        };
      };
    };
  };
}
