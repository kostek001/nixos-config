{ inputs, lib, system, ... }:

{
  imports = [
    ./nixpkgs-xr.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      arrpc = prev.arrpc.overrideAttrs (oldAttrs: {
        patches = [ ../misc/arrpc/log_ids.patch ];
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

    # TODO: move to kostek001/pkgs
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
              rev = "f742c38723bb44f90987c799f0fbf828e5e6c876";
              hash = "sha256-s3BMZI3FG/URWD8QzAZVdwSrx5pld4zdKoJ4lJ14DGc=";
            };

            buildInputs = (builtins.filter
              (x: !(lib.any (y: y == x)
                [ final.libdjinterop ]))
              oldAttrs.buildInputs)
            ++ [
              libdjinterop
              final.libjack2
            ];

            cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DQML=ON" ];

            postInstall = oldAttrs.postInstall + ''
              cp -r "$src/res/qml" "$out/share/mixxx"
            '';
          });
    })
  ];
}
