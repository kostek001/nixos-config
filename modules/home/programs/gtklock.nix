{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.kostek001.programs.gtklock;
in
{
  options.kostek001.programs.gtklock = {
    enable = mkEnableOption "GTKLock";

    package = mkPackageOption pkgs "gtklock" { };

    settings = mkOption {
      type = with types; attrsOf (oneOf [ bool float int str ]);
      default = { };
      description = ''
        Default arguments to {command}`gtklock`. An empty set
        disables configuration generation.
      '';
      example = {
        main = {
          gtk-theme = "Adwaita-dark";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."gtklock/config.ini" = mkIf (cfg.settings != { }) {
      text = (generators.toINI { } cfg.settings);
    };
  };
}
