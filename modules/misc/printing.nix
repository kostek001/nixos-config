{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.knix.misc.printing;
in
{
  options.knix.misc.printing = {
    enable = mkEnableOption "Printing";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      browsed.enable = false;
      drivers = with pkgs; [
        cups-filters
      ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
