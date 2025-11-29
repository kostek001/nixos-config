{ inputs, lib, system, ... }:

{
  imports = [
    ./nixpkgs-xr.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      master = inputs.nixpkgs-master.legacyPackages.${prev.system};
    })

    (final: prev: {
      arrpc = prev.arrpc.overrideAttrs (oldAttrs: {
        patches = [ ../misc/arrpc/log_ids.patch ];
      });
    })

    (final: prev: {
      glfw3-minecraft = prev.glfw3-minecraft.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          ../misc/glfw3-minecraft/Dont-crash-on-calls-to-icon.patch
        ];
      });
    })

    (final: prev: {
      opentabletdriver = prev.opentabletdriver.overrideAttrs (oldAttrs: {
        src = final.stdenv.mkDerivation {
          name = "opentabletdriver-src-patched";
          version = oldAttrs.version;
          src = oldAttrs.src;
          phases = [ "unpackPhase" "patchPhase" "installPhase" ];
          patches = [ ../misc/opentabletdriver/huion_hs611_config.patch ];
          installPhase = ''
            cp -r ./ $out/
          '';
        };
      });
    })

    (final: prev: {
      mixxx = prev.mixxx.overrideAttrs
        (oldAttrs:
          let
            libdjinterop = (final.libdjinterop.overrideAttrs (oldAttrs: rec {
              version = "0.26.1";
              src = oldAttrs.src.override {
                rev = version;
                hash = "sha256-HwNhCemqVR1xNSbcht0AuwTfpRhVi70ZH5ksSTSRFoc=";
              };
            }));
          in
          {
            version = "2.7-dev";
            src = oldAttrs.src.override {
              # main
              rev = "943ed6765dbcabfafd49e0068c6a5349adf6bd94";
              hash = "sha256-GCG2OBxmD/2JtSHXuIymBbZY6I6wkTAt6rdpbmce0mE=";
            };

            buildInputs = (builtins.filter
              (x: !(lib.any (y: y == x)
                [ final.libdjinterop ]))
              oldAttrs.buildInputs)
            ++ [
              libdjinterop
              final.libjack2
            ];
          });
    })

    # Version from nixpkgs-unstable has gpu graphs. Maybe removed in the future.
    (final: prev: {
      mission-center = inputs.nixpkgs-unstable.legacyPackages.${system}.mission-center;
    })
  ];
}
