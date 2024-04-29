{ lib, ... }:

lib.mkMerge [
  {
    # Minecraft
    networking.firewall.allowedTCPPorts = [
      25565
    ];
    networking.firewall.allowedUDPPorts = [
      25565
    ];
  }

  {
    # VR
    networking.firewall.allowedTCPPorts = [
      ## SlimeVR
      21110
    ];
    networking.firewall.allowedUDPPorts = [
      ## SlimeVR
      35903
      6969
    ];
  }
]
