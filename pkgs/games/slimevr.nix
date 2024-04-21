{ appimageTools, fetchurl }:
let
  name = "slimevr";
  version = "0.12.0-rc.1";
  hash = "sha256-+TVLgFVgmu4URZP4O+K6UQJAD3QG+TbPsIIVSfJBMAc=";

  src = fetchurl {
    url = "https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${version}/SlimeVR-amd64.appimage";
    inherit hash;
  };

  appimageContents = appimageTools.extract {
    inherit name version src;
  };
in
appimageTools.wrapType2 {
  inherit name version src;

  extraPkgs = pkgs: with pkgs; [ 
    cargo-tauri
    jdk17
    libusb1
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/slimevr.desktop $out/share/applications/slimevr.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256@2/apps/slimevr.png \
      $out/share/icons/hicolor/256x256@2/apps/slimevr.png
    substituteInPlace $out/share/applications/slimevr.desktop \
      --replace 'Exec=slimevr' 'Exec=${name}'
  '';
}