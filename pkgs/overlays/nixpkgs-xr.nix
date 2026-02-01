{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      wayvr = inputs.nixpkgs-xr.packages.${prev.stdenv.hostPlatform.system}.wayvr;
    })
    (final: prev: {
      xrizer = inputs.nixpkgs-xr.packages.${prev.stdenv.hostPlatform.system}.xrizer;
    })
    (final: prev: {
      opencomposite = inputs.nixpkgs-xr.packages.${prev.stdenv.hostPlatform.system}.opencomposite;
    })
  ];

  nix.settings = {
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
}
