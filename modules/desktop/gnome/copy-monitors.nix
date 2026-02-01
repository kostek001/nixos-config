{ cfg }: { lib, ... }:
with lib;

{
  config = mkIf cfg.copyMonitors.enable {
    systemd.user.services.gnome-copy-monitors = {
      description = "Copies monitors.xml on quit";

      wantedBy = [ "gnome-session-shutdown.target" ];
      after = [ "gnome-session-shutdown.target" ];

      script = "if ! cmp -s ~/.config/monitors.xml ${cfg.copyMonitors.path}; then cat ~/.config/monitors.xml > ${cfg.copyMonitors.path}; fi";
    };

    systemd.tmpfiles.rules = [
      "f ${cfg.copyMonitors.path} 664 root users - -"
      "L+ /run/gdm/.config/monitors.xml - - - - ${cfg.copyMonitors.path}"
    ];

    # TODO: copy monitors.xml to other users on login
  };
}
