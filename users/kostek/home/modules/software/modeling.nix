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
        (buildPythonPackage rec {
          pname = "py_slvs";
          version = "1.0.6";
          src = fetchPypi {
            inherit pname version;
            sha256 = "53a4ff697cb42530b5a6d2f9a0199c874cad48f98891103c5ce8b7d4da40ae72";
          };
          pyproject = true;
          propagatedBuildInputs = [ setuptools wheel scikit-build cmake ninja ];
          nativeBuildInputs = [ swig ];
          dontUseCmakeConfigure = true;
        })
      ]))
      openscad
      prusa-slicer
      #kicad
    ];
  };
}
