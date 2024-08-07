{ config, lib, pkgs, inputs, ... }:
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
      inputs.lemonake.packages.${pkgs.system}.alvr
      inputs.kostek001-pkgs.packages.${pkgs.system}.slimevr
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
          PYTHONUNBUFFERED=1 exec ${inputs.kostek001-pkgs.packages.${pkgs.system}.adb-auto-forward}/bin/adb-auto-forward.py 2833:0183,9943,9944,r9757
        '';
      };
    };

    services.steamvr = {
      runtimeOverride = {
        enable = true;
        path = "${pkgs.opencomposite}/lib/opencomposite";
      };
      activeRuntimeOverride = {
        enable = true;
        path = "${inputs.lemonake.packages.${pkgs.system}.wivrn}/share/openxr/1/openxr_wivrn.json";
      };
    };
  };
}
