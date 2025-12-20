{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.knix.misc.flatpak;
in
{
  options.knix.misc.flatpak = {
    enable = mkEnableOption "Flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    systemd.services.flatpak-add-remotes = {
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub ${./flathub.flatpakrepo}
      '';
    };
  };
}
