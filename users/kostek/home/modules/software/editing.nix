{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.khome.software.editing;
in
{
  options.khome.software.editing = {
    enable = mkEnableOption "Editing";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.kdenlive
      audacity
    ];
  };
}
