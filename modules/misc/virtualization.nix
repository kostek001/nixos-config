{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.knix.misc.virtualisation;
in
{
  options.knix.misc.virtualisation = {
    enable = mkEnableOption "Virtualization";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };

    knix.privileged.groups = [ "libvirtd" ];
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
