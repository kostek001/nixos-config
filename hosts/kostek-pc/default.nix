{ ... }:

{
  system.stateVersion = "23.11";
  imports = [
    ./customization.nix
    ./hardware-configuration.nix
    ./hardware.nix
  ];
}
