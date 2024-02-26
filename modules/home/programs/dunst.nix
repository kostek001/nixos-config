{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.programs.dunst;

  eitherStrBoolIntList = with types;
    either str (either bool (either int (listOf str)));
in
{
  options.kostek001.programs.dunst = {
    enable = mkEnableOption "Dunst";

    package = mkOption {
      type = types.package;
      default = pkgs.dunst;
      defaultText = literalExpression "pkgs.dunst";
      description = "Package providing {command}`dunst`.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = with types; attrsOf (attrsOf eitherStrBoolIntList);
      };
      default = { };
      description =
        "Configuration written to {file}`$XDG_CONFIG_HOME/dunst/dunstrc`.";
      example = literalExpression ''
        {
          global = {
            width = 300;
            height = 300;
            offset = "30x50";
            origin = "top-right";
            transparency = 10;
            frame_color = "#eceff1";
            font = "Droid Sans 9";
          };

          urgency_normal = {
            background = "#37474f";
            foreground = "#eceff1";
            timeout = 10;
          };
        };
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ];
    }

    (mkIf (cfg.settings != { })
      (
        let
          toDunstIni = generators.toINI {
            mkKeyValue = key: value:
              let
                value' =
                  if isBool value then
                    (lib.hm.booleans.yesNo value)
                  else if isString value then
                    ''"${value}"''
                  else
                    toString value;
              in
              "${key}=${value'}";
          };
        in
        {
          xdg.configFile."dunst/dunstrc" = {
            text = toDunstIni cfg.settings;
            onChange = ''
              ${pkgs.procps}/bin/pkill -u "$USER" ''${VERBOSE+-e} dunst || true
            '';
          };
        }
      ))
  ]);
}
