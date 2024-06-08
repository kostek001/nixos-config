{
  description = "Kostek001's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kostek001-pkgs = {
      url = "github:kostek001/nixos-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    plasma-smart-video-wallpaper-reborn = {
      url = "github:kostek001/plasma-smart-video-wallpaper-reborn";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HOME
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-23.11";
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
          ./modules
          ./global-config.nix
          ./pkgs/overlays.nix
          inputs.home-manager.nixosModules.home-manager
          { home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ]; }
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
              inherit hostname;
            };

            modules = [
              ./hosts/kostek-pc/config.nix
              ./type/desktop
            ] ++ defaultModules;
          };
      };
  };
}
