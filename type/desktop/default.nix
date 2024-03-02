{ pkgs, username, ... }:

{
  kostek001.boot.plymouth.enable = true;
  # kostek001.desktop.hyprland.enable = true;
  kostek001.desktop.plasma.enable = true;
  kostek001.misc.zsh.enable = true;

  kostek001.games.minecraft.enable = true;
  kostek001.games.steam.enable = true;
  kostek001.games.vr.enable = true;

  kostek001.hardware.adb.enable = true;
  kostek001.hardware.hid.enable = true;
  kostek001.hardware.opentabletdriver.enable = true;
  kostek001.hardware.platformio.enable = true;
  kostek001.hardware.sound.enable = true;
  hardware.bluetooth.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = { ... }: {
      home.stateVersion = "23.11";

      imports = [
        ../../modules/home
      ];

      programs.git = {
        enable = true;
        userName = "kostek001";
        userEmail = "example@example.net";
      };

      # Auto start
      wayland.windowManager.hyprland.settings.exec-once = [
        "[workspace 4 silent] vesktop"
        "noisetorch -i"
        "steam -silent"
      ];

      programs.kitty = {
        enable = true;
        font = {
          package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
          name = "FiraCode Nerd Font";
        };
        settings = {
          confirm_os_window_close = 0;
          background_opacity = "0.6";
          background_blur = 1;
        };
      };
    };
  };

  # ========================

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
  ];

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  imports = [
    ./pkgs.nix
  ];

  # Logon
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  #services.xserver.displayManager.defaultSession = "hyprland";
}
