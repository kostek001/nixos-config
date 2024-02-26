{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.services.wl-clip-persist;
in
{
  options.kostek001.services.wl-clip-persist = {
    enable = mkEnableOption "wl-clip-persist, preserve clipboard";

    package = mkPackageOption pkgs "wl-clip-persist" { };

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "sway-session.target";
      description = ''
        The systemd target that will automatically start the wl-clip-persist service.
      '';
    };

    settings = {
      clipboardType = mkOption {
        type = types.str;
        default = "regular";
        example = "both";
        description = ''
          Clipboard Type: regular, primary, both.
        '';
      };

      args = mkOption {
        type = types.str;
        default = "";
        example = "--read-timeout 50 --write-timeout 1000";
        description = ''
          Arguments added to end.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.wl-clip-persist = {
      Unit = {
        Description = "Clipboard persistent daemon";
        PartOf = [ cfg.systemdTarget ];
      };

      Service = {
        Type = "simple";
        ExecStart =
          "${cfg.package}/bin/wl-clip-persist --clipboard ${cfg.settings.clipboardType} ${cfg.settings.args}";
        Restart = "on-failure";
      };

      Install = { WantedBy = [ cfg.systemdTarget ]; };
    };
  };
}
