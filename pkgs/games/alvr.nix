{ appimageTools, fetchurl }:
let
  name = "alvr";
  version = "20.6.1";
  sha256 = "218c370f5f315065a216eef873877c778b68859ced003ea6999098b0337147e0";

  src = fetchurl {
    url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/ALVR-x86_64.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name version src;
  };
in
appimageTools.wrapType2 {
  inherit name version src;

  extraPkgs = pkgs: with pkgs; [ pulseaudio ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/alvr.desktop $out/share/applications/alvr.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/alvr.png \
      $out/share/icons/hicolor/256x256/apps/alvr.png
    substituteInPlace $out/share/applications/alvr.desktop \
      --replace 'Exec=alvr_dashboard' 'Exec=${name}'
  '';
}
