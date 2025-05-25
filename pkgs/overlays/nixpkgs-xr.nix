{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      wlx-overlay-s = inputs.nixpkgs-xr.packages.${prev.system}.wlx-overlay-s;
    })
    (final: prev: {
      xrizer = inputs.nixpkgs-xr.packages.${prev.system}.xrizer;
    })
    (final: prev: {
      opencomposite = inputs.nixpkgs-xr.packages.${prev.system}.opencomposite;
    })
  ];

  nix.settings = {
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
}
