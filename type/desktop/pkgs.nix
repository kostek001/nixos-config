{ pkgs, username, ... }:

{
  programs.noisetorch.enable = true;
  kostek001.programs.obs.enable = true;

  home-manager.users.${username} = { ... }: {
    home.packages = with pkgs; [
      # Thumbnails
      p7zip
      unar
    ] ++ [
      ## FRAMEWORKS
      python3
      python311Packages.pip

      ## TERMINAL
      cava
      appimage-run

      ## GRAPHICAL
      # Web browser
      master.brave
      # Editor
      (vscodium-fhsWithPackages (pkgs: with pkgs; [
        nixpkgs-fmt
        nixd
      ]))
      # Network
      bitwarden
      # Office
      libreoffice
      # Media
      vlc
      # Communication
      vesktop
    ] ++ [
      ## TERMINAL
      nodejs
      yt-dlp
      esptool

      ## GRAPHICAL
      # Web browser
      firefox
      # Editor
      arduino
      # Network
      nextcloud-client
      qbittorrent
      rustdesk-flutter
      veracrypt
      virt-manager
      # Art
      gimp
      inkscape-with-extensions
      krita
      libsForQt5.kdenlive
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
      prusa-slicer
      # Communication
      signal-desktop
      # Audio
      qpwgraph
      audacity
      # Containerization
      bottles
      # Disk utils
      kdiskmark
      rpi-imager
      # Other
      galaxy-buds-client
      (callPackage (import ../../pkgs/programs/ytermusic) { })
    ];
  };
}
