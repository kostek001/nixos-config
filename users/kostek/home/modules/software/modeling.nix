{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.khome.software.modeling;
in
{
  options.khome.software.modeling = {
    enable = mkEnableOption "Modeling";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (blender.withPackages (ps: with ps; [
        toml
        # py-slvs
      ]))
      openscad
      prusa-slicer
      #kicad
    ];
  };
}
