{ inputs, lib, ... }:

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
      glfw3-minecraft = prev.glfw3-minecraft.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          ./misc/glfw3-minecraft/Dont-crash-on-calls-to-icon.patch
        ];
      });
    })

    (final: prev: {
      wivrn = prev.wivrn.overrideAttrs (prevAttrs: {
        version = "0.23.2";
        src = prevAttrs.src.override {
          hash = "sha256-KpsS0XssSnE2Fj5rrXq1h+yNHhF7BzfPxwRUhZUZEaw=";
        };
        # cmakeFlags = prevAttrs.cmakeFlags ++ [
        #   (lib.cmakeFeature "OPENCOMPOSITE_SEARCH_PATH" "${final.opencomposite}")
        # ];
      });
    })
  ];
}
