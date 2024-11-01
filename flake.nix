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
        fullname = "Kostek";
        username = "kostek";

        defaultModules = [
          ./modules/nixos
          ./global-config.nix
          ./pkgs/overlays.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              inputs.agenix.homeManagerModules.default
              inputs.plasma-manager.homeManagerModules.plasma-manager
              inputs.lemonake.homeManagerModules.steamvr
              ./modules/home-manager
            ];
          }
          ./config
          inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
        ];
      in
      {
        kostek-pc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit username fullname;
          };
          modules = [
            { networking.hostName = "kostek-pc"; }
            ./hosts/kostek-pc/config.nix
          ] ++ defaultModules;
        };

        dellome = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit username fullname;
          };
          modules = [
            { networking.hostName = "dellome"; }
            ./hosts/dellome/config.nix
          ] ++ defaultModules;
        };

        dellete = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit username fullname;
          };
          modules = [
            { networking.hostName = "dellete"; }
            ./hosts/dellete/config.nix
          ] ++ defaultModules;
        };
      };
  };
}
