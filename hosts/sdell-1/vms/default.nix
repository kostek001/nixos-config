{ inputs, ... }:

{
  imports = [
    inputs.microvm.nixosModules.host

    ./mvpn
  ];

  networking.nftables.tables.nixos-nat.family = "ip";
}
