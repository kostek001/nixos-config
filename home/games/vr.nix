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
      (callPackage (import ../../pkgs/games/alvr.nix) { })
      pulseaudio

      (callPackage (import ../../pkgs/games/slimevr.nix) { })
    ] ++ [
      BeatSaberModManager
      sidequest
    ];


    systemd.user.services.vr-adb-auto-forward =
      let
        adb-auto-forward = pkgs.callPackage ../../pkgs/misc/adb-auto-forward.nix { };
      in
      {
        Unit = {
          Description = "ADB Auto Forward";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          # This is needed, otherwise no logs
          ExecStart = pkgs.writeShellScript "vr-adb-auto-forward" ''
            PYTHONUNBUFFERED=1 exec ${adb-auto-forward}/bin/adb-auto-forward.py 2833:0183,9943,9944
          '';
        };
      };

  };
}
