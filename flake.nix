{
  description = "Kostek001's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    kostek001-pkgs = {
      url = "github:kostek001/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lemonake = {
      url = "github:passivelemon/lemonake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    # HOME MANAGER
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations =
      let
        defaultModules = [
          ./global-config.nix
          ./modules
          ./pkgs/overlays.nix
          inputs.agenix.nixosModules.default
        ];

        createHost = (hostname: arch: extraModules:
          nixpkgs.lib.nixosSystem {
            system = arch;
            specialArgs = { inherit inputs; };
            modules = [
              { networking.hostName = hostname; }
              ./hosts/${hostname}
            ] ++ defaultModules ++ extraModules;
          });
      in
      {
        kostek-pc = createHost "kostek-pc" "x86_64-linux" [ ./profiles/desktop ];
        dellome = createHost "dellome" "x86_64-linux" [ ./profiles/desktop ];
        dellete = createHost "dellete" "x86_64-linux" [ ./profiles/desktop ];
      };
  };
}
