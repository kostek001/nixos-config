{ ... }:

{
  imports = [
    programs/dunst.nix
    programs/gtklock.nix
    services/cliphist.nix
    services/swayidle.nix
    services/swayosd.nix
    services/wl-clip-persist.nix
  ];
}