{ config, lib, ... }:
with lib;

let
  cfg = config.knix.misc.doas;
in
{
  options.knix.misc.doas = {
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

    security.doas.wheelNeedsPassword = mkDefault config.security.sudo.wheelNeedsPassword;

    # Disable sudo
    security.sudo.enable = false;

    # Aliases
    environment.shellAliases = {
      sudo = "doas";
      sudoedit = "doas rnano";
    };
  };
}
