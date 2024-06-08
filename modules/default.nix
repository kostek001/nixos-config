{ ... }:

{
  imports = [
    boot/plymouth.nix
    boot/loader/lanzaboote.nix
    desktop/hyprland
    desktop/plasma.nix
    games/steam.nix
    hardware/adb.nix
    hardware/hid.nix
    hardware/nvidia.nix
    hardware/opentabletdriver.nix
    hardware/platformio.nix
    hardware/sound.nix
    misc/doas.nix
    misc/shell-utils.nix
    misc/zsh.nix
    services/swayosd-backend.nix
  ];
}
