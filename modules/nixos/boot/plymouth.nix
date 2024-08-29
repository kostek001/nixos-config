{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.boot.plymouth;
in
{
  options.kostek001.boot.plymouth = {
    enable = mkEnableOption "Plymouth";
  };

  config = mkIf cfg.enable {
    boot.initrd.systemd.enable = true;

    boot.plymouth = {
      enable = true;
      font = "${pkgs.noto-fonts.override { variants = [ "NotoSans" ]; }}/share/fonts/noto/NotoSans[wdth,wght].ttf";
      theme = "hexagon_2";
      themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ config.boot.plymouth.theme ]; }) ];
    };

    boot.kernelParams = [ "quiet" ];
  };
}
