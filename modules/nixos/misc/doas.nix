{ config, lib, ... }:
with lib;

let
  cfg = config.kostek001.misc.doas;
in
{
  options.kostek001.misc.doas = {
    enable = mkEnableOption "Doas";
  };

  config = mkIf cfg.enable {
    security.doas = {
      enable = true;
      extraRules = [{
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }];
    };

    # Disable sudo
    security.sudo.enable = false;

    # Aliases
    environment.shellAliases = {
      sudo = "doas";
      sudoedit = "doas rnano";
    };
  };
}
