{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      master = inputs.nixpkgs-master.legacyPackages.${prev.system};
    })

    (final: prev: {
      arrpc = prev.arrpc.overrideAttrs (oldAttrs: {
        patches = [ misc/arrpc/log_ids.patch ];
      });
    })

    inputs.kostek001-pkgs.overlays.default

    # TEMPORARY
    (final: prev: {
      wlx-overlay-s = prev.master.wlx-overlay-s;
    })
  ];
}
