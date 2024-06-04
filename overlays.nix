{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    (import ./pkgs)
    (final: prev: {
      master = inputs.nixpkgs-master.legacyPackages.x86_64-linux;
    })

    (final: prev:
      prev.arrpc.overrideAttrs (final: prev: {
        patches = [ ../../pkgs/misc/arrpc/log_ids.patch ];
      })
    )
  ];
}
