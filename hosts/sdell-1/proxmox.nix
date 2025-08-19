{ lib, inputs, system, ... }:

{
  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];

  environment.persistence."/nix/persist".directories = [
    "/var/lib/pve-cluster"
  ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.4.13";
    bridges = [ "vmbr0" ];
  };

  # Set up `vmbr0` bridge
  networking.bridges.vmbr0.interfaces = [ "ether0" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
