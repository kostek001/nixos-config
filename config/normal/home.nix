{ configType }: { lib, pkgs, ... }:

{
  config = lib.mkIf configType.normal {
    kostek001.games.minecraft.enable = true;
    kostek001.programs.obs.enable = true;

    programs.cava = {
      enable = true;
      settings = {
        general = {
          framerate = 100;
          bar_width = 1;
          bar_spacing = 1;
        };
        output.method = "noncurses";
        color = {
          gradient = 1;
          gradient_count = 7;
          gradient_color_1 = "'#0080ff'";
          gradient_color_2 = "'#ae00ff'";
          gradient_color_3 = "'#b84da3'";
          gradient_color_4 = "'#d77689'";
          gradient_color_5 = "'#e29878'";
          gradient_color_6 = "'#a5a875'";
          gradient_color_7 = "'#b4eb8c'";
        };
      };
    };

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      extensions = [ ];
      package = pkgs.vscodium-fhsWithPackages
        (pkgs: with pkgs; [
          nixpkgs-fmt
          nixd
          # PlatformIO
          python3
          sops
        ]);
    };

    # For Discord
    services.arrpc.enable = true;

    home.packages = with pkgs; [
      appimage-run
      esptool
    ] ++ [
      brave
      bitwarden
      bottles
      youtube-music

      # Network
      nextcloud-client
      qbittorrent

      # Communication
      signal-desktop
      element-desktop
      vesktop

      # Creativity
      gimp
      inkscape-with-extensions
      krita
      kdePackages.kdenlive
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
      kicad
      audacity
    ];
  };
}
