{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      master = inputs.nixpkgs-master.legacyPackages.${prev.system};
    })

    (final: prev: {
      arrpc = prev.arrpc.overrideAttrs (oldAttrs: {
        patches = [ pkgs/misc/arrpc/log_ids.patch ];
      });
    })

    # TEMPORARY
    (final: prev: {
      nixd = prev.master.nixd;
    })
  ];
}
