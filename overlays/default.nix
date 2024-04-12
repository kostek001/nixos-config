{config, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      orca-slicer = prev.callPackage ./orca-slicer/ { };
    })
  ];
}