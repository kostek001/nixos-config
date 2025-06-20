{ config, pkgs, ... }:

{
  khome.games.minecraft.enable = true;
  khome.obs.enable = true;

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
    package = pkgs.vscodium.fhsWithPackages
      (pkgs: with pkgs; [
        nixpkgs-fmt
        nixd
        # PlatformIO
        python3
        sops
        # C++
        gcc
        gdb
        # Java
        openjdk21
      ]);
  };

  age.secrets."wakatime.cfg" = {
    file = ../../secrets/wakatime.cfg.age;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };

  # For Discord
  services.arrpc.enable = true;

  home.packages = with pkgs; [
    brave
    bitwarden
    bottles

    # Network
    qbittorrent
    # planify # TODO: re add – fails to build

    # Communication
    signal-desktop
    element-desktop
    vesktop
    winbox4

    # Creativity
    gimp3
    inkscape-with-extensions
    krita
  ];

  # Autostart
  xdg.configFile."autostart/Vesktop.desktop".text =
    let
      script = pkgs.writeScript "vesktop-start" ''
        #!/usr/bin/env bash
        sleep 15 && vesktop --start-minimized
      '';
    in
    ''
      [Desktop Entry]
      Categories=Network;InstantMessaging;Chat
      Exec=${script}
      GenericName=Internet Messenger
      Icon=vesktop
      Keywords=discord;vencord;electron;chat
      Name=Vesktop
      StartupWMClass=Vesktop
      Type=Application
      Version=1.4
    '';
}
