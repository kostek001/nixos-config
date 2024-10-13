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
      glfw3-minecraft = prev.glfw3-minecraft.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          ./misc/glfw3-minecraft/Dont-crash-on-calls-to-icon.patch
        ];
      });
    })

    # Temporary update to 0.0.6
    (final: prev: {
      beatsabermodmanager = final.callPackage ./games/beatsabermodmanager/package.nix { };
    })
  ];
}
