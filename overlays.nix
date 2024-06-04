{ inputs, ... }:

{
  nixpkgs.overlays = [
    (import ./pkgs)
    
    (final: prev: {
      master = inputs.nixpkgs-master.legacyPackages.x86_64-linux;
    })

    (final: prev: {
      arrpc = prev.arrpc.overrideAttrs (oldAttrs: {
        patches = [ pkgs/misc/arrpc/log_ids.patch ];
      });
    })
  ];
}
