{
  description = "Kostek001's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs: with inputs; {
    nixosConfigurations =
      let
        fullname = "Kostek";
        username = "kostek";

        defaultModules = [
          ./modules
          ./global-config.nix
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

              home-manager.nixosModules.home-manager

              {
                environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
              }
              # UNSTABLE Overlay
              # ({ config, ... }: {
              #   nixpkgs.overlays = [
              #     (final: prev: {
              #       unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
              #     })
              #   ];
              # })
            ] ++ defaultModules;
          };
      };
  };
}
