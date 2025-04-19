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
        version = "0.24.1";
        src = prevAttrs.src.override {
          hash = "sha256-aWQcGIrBoDAO7XqWb3dQLBKg5RZYxC7JxwZ+OBSwmEs=";
        };
        # cmakeFlags = prevAttrs.cmakeFlags ++ [
        #   (lib.cmakeFeature "OPENCOMPOSITE_SEARCH_PATH" "${final.opencomposite}")
        # ];
      });
    })
  ];
}
