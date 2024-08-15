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
      url = "github:nix-community/lanzaboote";
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
        fullname = "Kostek";
        username = "kostek";

        defaultModules = [
          ./modules/nixos
          ./global-config.nix
          ./pkgs/overlays.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              inputs.plasma-manager.homeManagerModules.plasma-manager
              inputs.lemonake.homeManagerModules.steamvr
              ./modules/home-manager
            ];
          }
          ./config
        ];
      in
      {
        kostek-pc =
          let
            hostname = "kostek-pc";
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = {
              inherit inputs;
              inherit username fullname;
            };

            modules = [
              { networking.hostName = hostname; }
              { kostek001.config.type = "full"; }
              ./hosts/kostek-pc/config.nix
            ] ++ defaultModules;
          };
      };
  };
}
