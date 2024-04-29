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

    # services.udev = (
    #   let
    #     script = pkgs.writeScriptBin "alvr-adb-forward" ''
    #       #!/bin/sh
    #       ${pkgs.android-tools}/bin/adb start-server
    #       ${pkgs.android-tools}/bin/adb forward tcp:9943 tcp:9943
    #       ${pkgs.android-tools}/bin/adb forward tcp:9944 tcp:9944
    #     '';
    #   in
    #   {
    #     enable = true;
    #     extraRules = ''
    #       ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2833", ATTRS{idProduct}=="0183", RUN+="${pkgs.su}/bin/su kostek -c '${script}/bin/alvr-adb-forward > /tmp/ll.txt'"
    #     '';
    #   }
    # );
  };
}
