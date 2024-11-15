{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hid.nix
    ./steam.nix
  ];

  programs.adb.enable = true;
  knix.privileged.groups = [ "adbusers" ];

  # Use Firefox beta
  programs.firefox.package = inputs.firefox.packages.${pkgs.system}.firefox-beta-bin;

  knix.hardware.platformio.enable = true;

  # For OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  # Minecraft
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
