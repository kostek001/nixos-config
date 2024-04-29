{ ... }:

{
  imports = [
    boot/plymouth.nix
    boot/loader/lanzaboote.nix
    desktop/hyprland
    desktop/gnome.nix
    desktop/plasma.nix
    games/steam.nix
    hardware/adb.nix
    hardware/hid.nix
    hardware/nvidia.nix
    hardware/opentabletdriver.nix
    hardware/platformio.nix
    hardware/sound.nix
    misc/doas.nix
    misc/zsh.nix
    programs/obs.nix
    programs/shell-utils.nix
    services/swayosd-backend.nix
  ];
}
