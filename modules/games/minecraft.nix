{ config, lib, pkgs, username, ... }:
with lib;

let
  cfg = config.kostek001.games.minecraft;
in
{
  options.kostek001.games.minecraft = {
    enable = mkEnableOption "Minecraft";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (unstable.prismlauncher.override {
        jdks = [ jdk8 jdk17 jdk21 ];
        withWaylandGLFW = true;
      })
      lunar-client
    ];

    # Open ports
    networking.firewall.allowedTCPPorts = [
      25565
    ];
    networking.firewall.allowedUDPPorts = [
      25565
    ];

    home-manager.users.${username} = { ... }: {
      # Fix audio
      home.file.".alsoftrc".text = ''
        [general]
        drivers = pulse

        [pulse]
        allow-moves=yes
      '';
    };
  };
}
