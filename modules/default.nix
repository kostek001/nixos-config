{ ... }:

{
  imports = [
    boot/plymouth.nix
    boot/loader/lanzaboote.nix
    # desktop/hyprland # TODO: fix hyprland module
    desktop/gnome
    desktop/plasma.nix
    hardware/nvidia.nix
    hardware/platformio.nix
    misc/flatpak
    misc/doas.nix
    misc/printing.nix
    misc/shell-utils.nix
    misc/libvirt.nix
    ./privileged.nix
  ];
}
