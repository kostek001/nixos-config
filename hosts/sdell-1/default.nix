{ inputs, ... }:

{
  system.stateVersion = "24.11";
  imports = [
    ./customization.nix
    ./hardware-configuration.nix
    ./hardware.nix

    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];
}
