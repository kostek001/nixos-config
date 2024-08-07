{ config, pkgs, username, inputs, ... }:

{
  kostek001.boot.plymouth.enable = true;
  kostek001.desktop.plasma.enable = true;
  kostek001.misc.zsh.enable = true;

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
    users.${username} = import ./home.nix;
    backupFileExtension = "hm-backup";
  };

  # ========================

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
  ];

  # Logon
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  };
  users.users.${username}.extraGroups = [ "libvirtd" ];

  # Expand user tmp
  services.logind.extraConfig = "RuntimeDirectorySize=40%";

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  # For OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  # Remove xterm
  services.xserver.excludePackages = [ pkgs.xterm ];

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    package = inputs.firefox.packages.${pkgs.system}.firefox-beta-bin;
  };

  services.flatpak.enable = true;

  imports = [
    ./pkgs.nix
    ./firewall.nix
  ];
}
