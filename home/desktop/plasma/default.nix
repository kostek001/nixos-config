{ config, lib, ... }:

let
  cfg = config.kostek001.desktop.plasma;
in
{
  imports = [
    <plasma-manager/modules>
  ];

  options.kostek001.desktop.plasma = {
    enable = lib.mkEnableOption "Plasma";
  };

  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      shortcuts = {
        "services/org.kde.konsole.desktop"."_launch" = "Meta+T";
      };
    };
  };
}
