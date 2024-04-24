{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.games.vr;
in
{
  options.kostek001.games.vr = {
    enable = mkEnableOption "VR";
  };

  config = mkIf cfg.enable (lib.mkMerge [
    ({
      ## ALVR
      environment.systemPackages = with pkgs; [
        (callPackage (import ../../pkgs/games/alvr.nix) { })
        (callPackage (import ../../pkgs/games/slimevr.nix) { })
        pulseaudio
      ];

      # services.udev = (
      #   let
      #     script = pkgs.writeScriptBin "alvr-adb-forward" ''
      #       #!/bin/sh
      #       ${pkgs.android-tools}/bin/adb start-server ?> /tmp/ll.txt
      #       ${pkgs.android-tools}/bin/adb forward tcp:9943 tcp:9943
      #       ${pkgs.android-tools}/bin/adb forward tcp:9944 tcp:9944
      #     '';
      #   in
      #   {
      #     enable = true;
      #     extraRules = ''
      #       ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2833", ATTRS{idProduct}=="0183", RUN+="${pkgs.su}/bin/su kostek -c '${script}/bin/alvr-adb-forward'"
      #     '';
      #   }
      # );
    })

    ({
      ## OTHER
      environment.systemPackages = with pkgs; [
        BeatSaberModManager
        sidequest
      ];
      networking.firewall.allowedTCPPorts = [
        ## SLIMEVR
        21110
      ];
      networking.firewall.allowedUDPPorts = [
        ## SLIMEVR
        35903
        6969
      ];
    })
  ]);
}
