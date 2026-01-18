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

    # Allow users with `flatpak` group to install apps system-wide
    users.groups.flatpak = { };
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.Flatpak.app-install" ||
             action.id == "org.freedesktop.Flatpak.app-uninstall" ||
             action.id == "org.freedesktop.Flatpak.app-update" ||
             action.id == "org.freedesktop.Flatpak.runtime-install" ||
             action.id == "org.freedesktop.Flatpak.runtime-uninstall" ||
             action.id == "org.freedesktop.Flatpak.runtime-update" ||
             action.id == "org.freedesktop.Flatpak.metadata-update") &&
            subject.active && 
            subject.isInGroup("flatpak")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
