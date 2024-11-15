{ username }: { config, lib, ... }:
with lib;

let
  cfg = config.knix.users.kostek.autologin;
in
{
  options.knix.users.kostek.autologin = {
    enable = mkEnableOption "Autologin";
  };

  config = mkIf cfg.enable {
    services.displayManager.autoLogin = {
      enable = true;
      user = username;
    };
  };
}
