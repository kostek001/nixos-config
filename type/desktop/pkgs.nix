{ pkgs, username, ... }:

{
  virtualisation.vmware.host.enable = true;
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;
  programs.noisetorch.enable = true;
  kostek001.programs.obs.enable = true;

  home-manager.users.${username} = { ... }: {
    home.packages = with pkgs; [
      ## KDE
      libsForQt5.filelight
      libsForQt5.kcalc
      # Network mounting
      kio-fuse
      libsForQt5.kio-extras
      # Thumbnails
      libsForQt5.kdegraphics-thumbnailers
      ghostscript
    ] ++ [
      ## FRAMEWORKS
      python3
      python311Packages.pip

      ## TERMINAL
      cava
      appimage-run
      # Other
      pulsemixer
      bluetuith

      ## GRAPHICAL
      # Web browser
      brave
      # Editor
      (vscodium-fhsWithPackages (pkgs: with pkgs; [
        nixpkgs-fmt
        nixd
      ]))
      # Network
      bitwarden
      # Office
      libreoffice
      logseq
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
      #rustdesk
      moonlight-qt
      # Art
      gimp
      inkscape-with-extensions
      krita
      libsForQt5.kdenlive
      blender
      # Communication
      signal-desktop
      # Audio
      helvum
      qpwgraph
      audacity
      # Containerization
      bottles
      # Disk utils
      kdiskmark
      rpi-imager
      # Other
      galaxy-buds-client
    ];
  };
}
