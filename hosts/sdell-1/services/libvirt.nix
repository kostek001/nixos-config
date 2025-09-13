{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
  };
  knix.privileged.groups = [ "libvirtd" ];

  environment.persistence."/nix/persist".directories = [
    "/var/lib/libvirt/"
  ];
}
