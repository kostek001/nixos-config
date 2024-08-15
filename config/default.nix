{ config, lib, username, ... }:
let
  cfg = config.kostek001.config.type;

  getIndex = element: lib.lists.findFirstIndex (x: x == element) null configTypes;
  configType = builtins.listToAttrs (builtins.map (x: { name = x; value = (getIndex x) <= (getIndex cfg); }) configTypes);

  configTypes = [ "minimal" "normal" "full" ];
in
{
  options.kostek001.config.type = lib.mkOption {
    type = lib.types.enum configTypes;
    default = "minimal";
    #apply = option: builtins.listToAttrs (builtins.map (x: { name = x; value = (getIndex x) <= (getIndex option); }) configTypes);
  };

  imports = [
    (import ./config.nix { inherit configType; })
  ];

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.${username} = { ... }: {
        imports = [ (import ./home.nix { inherit configType; }) ];
        home.stateVersion = "23.11";
      };
    };
  };
}
