{ config, lib, ... }:
with lib;

let
  cfg = config.khome.gnome;
in
{
  options.khome.gnome = {
    enable = mkEnableOption "Gnome";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "Terminal";
      };
    };
  };
}
