{ config, ... }:

{
  imports = [
    ./steam.nix
  ];

  programs.adb.enable = true;
  knix.privileged.groups = [ "adbusers" ];

  knix.hardware.platformio.enable = true;

  # For OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  # Minecraft
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
