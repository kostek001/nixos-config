{ cfg }: { lib, ... }:
with lib;

{
  config = mkIf cfg.remote-desktop.enable {
    systemd.services."gnome-remote-desktop".wantedBy = [ "graphical.target" ];
    networking.firewall = {
      allowedTCPPorts = [ 3389 ];
      allowedUDPPorts = [ 3389 ];
    };
  };
}
