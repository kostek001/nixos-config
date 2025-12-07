{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.knix.misc.libvirt;
in
{
  options.knix.misc.libvirt = {
    enable = mkEnableOption "Libvirt";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = [ pkgs.virtiofsd ];
        swtpm.enable = true;
      };
      allowedBridges = [ "virbr-user0" "virbr-user1" "virbr-user2" ];
    };

    knix.privileged.groups = [ "libvirtd" ];
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
