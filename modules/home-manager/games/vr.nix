{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.games.vr;
in
{
  options.kostek001.games.vr = {
    enable = mkEnableOption "VR";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alvr
      pulseaudio

      slimevr
    ] ++ [
      BeatSaberModManager
      sidequest
    ];


    systemd.user.services.adb-auto-forward = {
      Unit = {
        Description = "ADB Auto Forward";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        # This is needed, otherwise no logs
        ExecStart = pkgs.writeShellScript "adb-auto-forward" ''
          PYTHONUNBUFFERED=1 exec ${pkgs.adb-auto-forward}/bin/adb-auto-forward.py 2833:0183,9943,9944,r9757
        '';
      };
    };
  };
}
