{ pkgs, username, ... }:

{
  kostek001.boot.plymouth.enable = true;
  kostek001.desktop.plasma.enable = true;
  kostek001.misc.zsh.enable = true;

  kostek001.games.steam.enable = true;

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

  virtualisation.libvirtd.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];

  services.logind.extraConfig = "RuntimeDirectorySize=40%";

  imports = [
    ./pkgs.nix
    ./firewall.nix
  ];
}
