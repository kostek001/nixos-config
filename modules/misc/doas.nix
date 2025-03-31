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
      wheelNeedsPassword = mkDefault config.security.sudo.wheelNeedsPassword;
      extraRules = lib.optionals config.security.doas.wheelNeedsPassword [{
        groups = [ "wheel" ];
        persist = true;
        keepEnv = true;
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
