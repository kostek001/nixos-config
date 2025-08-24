{ pkgs, inputs, ... }:

{
  imports = [
    inputs.microvm.nixosModules.host

    ./mvpn.nix
  ];

  nixpkgs.overlays = [
    # Temporary overwrite for QEMU 10.x.x
    (final: prev: {
      qemu = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.qemu;
    })

    (final: prev: {
      amneziawg-go = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.amneziawg-go;
      amneziawg-tools = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.amneziawg-tools;
    })
  ];

  # LIBVIRT
  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
  };
  knix.privileged.groups = [ "libvirtd" ];

  environment.persistence."/nix/persist".directories = [
    "/var/lib/libvirt/"
  ];
}
