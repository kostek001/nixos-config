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

    # TEMPORARY
    (final: prev: {
      nixd = prev.master.nixd;
    })

    inputs.kostek001-pkgs.overlays.default
  ];
}
