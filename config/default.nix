{ config, lib, username, ... }:
let
  cfg = config.kostek001.config.type;

  configType = builtins.listToAttrs (builtins.map (x: { name = x; value = builtins.elem x cfg; }) availableConfigTypes);

  availableConfigTypes = [ "minimalDesktop" "normalDesktop" "fullDesktop" "pentesting" ];
in
{
  options.kostek001.config.type = lib.mkOption {
    type = with lib.types; listOf (enum availableConfigTypes);
    default = [ ];
    #apply = option: builtins.listToAttrs (builtins.map (x: { name = x; value = (getIndex x) <= (getIndex option); }) configTypes);
  };

  imports = [ (import ./nixos.nix { inherit configType; }) ];

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.${username} = { ... }: {
        imports = [ (import ./home-manager.nix { inherit configType; }) ];
        home.stateVersion = "23.11";
      };
    };
  };
}
