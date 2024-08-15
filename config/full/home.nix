{ configType }: { lib, pkgs, ... }:

{
  config = lib.mkIf configType.full {
    kostek001.games.vr.enable = true;

    home.packages = with pkgs; [
      kdiskmark
      rpi-imager
    ];
  };
}
