{ inputs, ... }:

{
  imports = [
    inputs.microvm.nixosModules.host

    ./mvpn
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
}
