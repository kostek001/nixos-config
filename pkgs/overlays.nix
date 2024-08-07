{ lib, inputs, ... }:

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

    (final: prev: {
      egl-wayland = prev.egl-wayland.overrideAttrs (oldAttrs: {
        version = "c439cd596fb7eadae69012eaba013c39b2377771";
        src = oldAttrs.src.override (_: {
          hash = "sha256-MD+D/dRem3ONWGPoZ77j2UKcOCUuQ0nrahEQkNVEUnI=";
        });
      });
    })

    (final: prev: {
      wlx-overlay-s = prev.master.wlx-overlay-s;
    })
  ];
}
