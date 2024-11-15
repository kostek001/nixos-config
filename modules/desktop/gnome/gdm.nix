{ cfg }: { config, lib, ... }:
with lib;

{
  config = mkIf cfg.gdm.enable {
    services.displayManager.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    # Automatic login fix
    systemd.services = mkIf config.services.displayManager.autoLogin.enable {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    # Set monitors in GDM
    systemd.tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - /home/kostek/.config/monitors.xml"
    ];
  };
}
