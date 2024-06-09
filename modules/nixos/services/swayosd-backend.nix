{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.services.swayosd-backend;
in
{
  options.kostek001.services.swayosd-backend = {
    enable = mkEnableOption "SwayOSD backend";

    package = mkPackageOption pkgs "swayosd" { };

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical.target";
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ cfg.package ];

    systemd.services.swayosd-libinput-backend = {
      description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
      partOf = [ "graphical.target" ];
      after = [ "graphical.target" ];
      documentation = [ "https://github.com/ErikReider/SwayOSD" ];

      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "${cfg.package}/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };

      wantedBy = [ cfg.systemdTarget ];
    };
  };
}
