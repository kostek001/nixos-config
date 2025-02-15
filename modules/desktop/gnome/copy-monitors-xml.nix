{ cfg }: { lib, ... }:
with lib;

{
  config = mkIf cfg.copyMonitorsXml.enable {
    systemd.user.services.gnome-copy-monitors-xml = {
      description = "Copies monitors.xml on quit";

      wantedBy = [ "gnome-session-shutdown.target" ];
      after = [ "gnome-session-shutdown.target" ];

      script = "cat ~/.config/monitors.xml > ${cfg.copyMonitorsXml.path}";
    };

    systemd.tmpfiles.rules = [
      "f ${cfg.copyMonitorsXml.path} 664 root users - -"
      "L+ /run/gdm/.config/monitors.xml - - - - ${cfg.copyMonitorsXml.path}"
    ];
  };
}
