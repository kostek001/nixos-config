{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.services.cliphist;
in
{
  options.kostek001.services.cliphist = {
    enable = mkEnableOption "cliphist, a clipboard history “manager” for wayland";

    package = mkPackageOption pkgs "cliphist" { };

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "sway-session.target";
      description = ''
        The systemd target that will automatically start the cliphist service.

        When setting this value to `"sway-session.target"`,
        make sure to also enable {option}`wayland.windowManager.sway.systemd.enable`,
        otherwise the service may never be started.
      '';
    };

    settings = {
      maxDedupeSearch = mkOption {
        type = types.int;
        default = 20;
        example = 10;
        description = ''
          Maximum number of last items to look through when finding duplicates.
        '';
      };

      maxItems = mkOption {
        type = types.int;
        default = 750;
        example = 100;
        description = ''
          Maximum number of items to store.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (hm.assertions.assertPlatform "services.cliphist" pkgs platforms.linux)
    ];

    home.packages = [ cfg.package ];

    systemd.user.services.cliphist = {
      Unit = {
        Description = "Clipboard management daemon";
        PartOf = [ cfg.systemdTarget ];
      };

      Service = {
        Type = "simple";
        ExecStart =
          "${pkgs.wl-clipboard}/bin/wl-paste --watch ${cfg.package}/bin/cliphist -max-dedupe-search ${builtins.toString cfg.settings.maxDedupeSearch} -max-items ${builtins.toString cfg.settings.maxItems}  store";
        Restart = "on-failure";
      };

      Install = { WantedBy = [ cfg.systemdTarget ]; };
    };
  };
}
