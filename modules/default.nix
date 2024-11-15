{ ... }:

{
  imports = [
    boot/plymouth.nix
    boot/loader/lanzaboote.nix
    # desktop/hyprland # TODO: fix hyprland module
    desktop/gnome
    desktop/plasma.nix
    hardware/nvidia.nix
    hardware/opentabletdriver.nix
    hardware/platformio.nix
    misc/doas.nix
    misc/shell-utils.nix
    misc/virtualization.nix
    ./privileged.nix
  ];
}
