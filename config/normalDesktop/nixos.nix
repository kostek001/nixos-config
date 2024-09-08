{ configType }: { config, lib, pkgs, ... }:

{
  config = lib.mkIf configType.normalDesktop {
    # STEAM
    programs.steam.enable = true;
    programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
      protonup-qt
    ];

    # For OBS virtual camera
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    # Minecraft
    networking.firewall.allowedTCPPorts = [ 25565 ];
    networking.firewall.allowedUDPPorts = [ 25565 ];
  };
}
