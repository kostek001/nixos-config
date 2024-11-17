# nixos-config

My personal NixOS and Home Manager configuration.

## Structure

- `hosts/` – contains host specific configuration
- `modules/` – contains custom NixOS modules
- `pkgs/` – contains NixOS overlays, patches
- `profiles/` – contains host profiles (desktop)
- `users/` – contains user specific configuration
  - `home/` – Home Manager configuration
  - `nixos/` – NixOS configuration
  - `resources/` – non-configuration files (wallpapers, etc.)

## Features

- Desktop environments:
  - _GNOME_ – configured using _dconf_
  - _KDE Plasma_ – declared with _plasma-manager_
- Drivers:
  - _NVIDIA_
  - _OpenTabletDriver_
- Extra:
  - Secureboot – _Lanzaboote_
  - VR – _ALVR_, _WiVRN_, _adb-auto-forward_
  - Impermanence – root filesystem on _TmpFS_ + _BTRFS_
