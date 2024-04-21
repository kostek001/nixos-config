{ appimageTools, fetchurl }:
let
  name = "slimevr";
  version = "0.12.0-rc.3";
  sha256 = "fa02ca136139df10abf19fccba6f5b470b1ba2cfca3abf6b250a47a113ea7501";

  src = fetchurl {
    url = "https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${version}/SlimeVR-amd64.appimage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name version src;
  };
in
appimageTools.wrapType2 {
  inherit name version src;

  extraPkgs = pkgs: with pkgs; [ cargo-tauri ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/slimevr.desktop $out/share/applications/slimevr.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256@2/apps/slimevr.png \
      $out/share/icons/hicolor/256x256@2/apps/slimevr.png
    substituteInPlace $out/share/applications/slimevr.desktop \
      --replace 'Exec=slimevr' 'Exec=${name}'
  '';
}