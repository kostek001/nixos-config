{ ... }:

{
  system.stateVersion = "25.05";
  imports = [
    ./customization.nix
    ./hardware.nix
  ];
}
