{ configType }: { lib, pkgs, username, ... }:

{
  config = lib.mkIf configType.fullDesktop {
    kostek001.games.vr.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
    users.users.${username}.extraGroups = [ "libvirtd" ];
    environment.systemPackages = with pkgs; [ virt-manager ];

    # Expand user tmp
    services.logind.extraConfig = "RuntimeDirectorySize=40%";
  };
}
