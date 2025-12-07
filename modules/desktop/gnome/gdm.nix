{ cfg }: { lib, ... }:
with lib;

{
  config = mkIf cfg.gdm.enable {
    services.displayManager.enable = true;
    services.displayManager.gdm.enable = true;

    # Disable default console
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
