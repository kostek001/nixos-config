{ ... }:

{
  imports = [
    boot/plymouth.nix
    boot/loader/lanzaboote.nix
    desktop/hyprland
    desktop/plasma.nix
    games/vr.nix
    hardware/nvidia.nix
    hardware/opentabletdriver.nix
    hardware/platformio.nix
    misc/doas.nix
    misc/shell-utils.nix
    services/swayosd-backend.nix
  ];
}
