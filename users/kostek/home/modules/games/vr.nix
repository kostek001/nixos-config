{ config, lib, pkgs, inputs, ... }:
with lib;

let
  cfg = config.khome.games.vr;
in
{
  options.khome.games.vr = {
    enable = mkEnableOption "VR";
  };

  imports = [
    inputs.lemonake.homeModules.steamvr
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wlx-overlay-s
      #beatsabermodmanager
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

    programs.steamvr = {
      enable = true;
      openvrRuntimeOverride = {
        enable = true;
        config = "path";
        # path = "${pkgs.opencomposite}/lib/opencomposite";
        path = "${pkgs.xrizer}/lib/xrizer";
      };
      openxrRuntimeOverride = {
        enable = true;
        config = "path";
        path = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";
      };
    };

    xdg.configFile."wivrn/config.json".text = builtins.toJSON
      {
        application = [ "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s" ];
        bitrate = 150 * 1000000;
        "tcp_only" = true;
        "publish-service" = null;
      };

    xdg.configFile."wlxoverlay/wayvr.conf.d/dashboard.yaml".source = (pkgs.formats.yaml { }).generate "wlxoverlay-wayvr-dashboard.yaml"
      {
        dashboard = {
          exec = "${inputs.nixpkgs-xr.packages.${pkgs.system}.wayvr-dashboard}/bin/wayvr-dashboard";
          args = "";
          env = [ ];
        };
      };
  };
}
