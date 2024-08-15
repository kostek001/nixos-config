{ configType }: { lib, pkgs, username, ... }:

{
  config = lib.mkIf configType.full {
    kostek001.games.vr.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
    users.users.${username}.extraGroups = [ "libvirtd" ];
    environment.systemPackages = with pkgs; [ virt-manager ];

    # Expand user tmp
    services.logind.extraConfig = "RuntimeDirectorySize=40%";

    # Minecraft
    networking.firewall.allowedTCPPorts = [ 25565 ];
    networking.firewall.allowedUDPPorts = [ 25565 ];
  };
}
