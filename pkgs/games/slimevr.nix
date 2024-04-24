{ appimageTools, fetchurl, glib }:
let
  name = "slimevr";
  version = "0.12.0-rc.4";

  src = appimageTools.extract {
    inherit name version;

    src = fetchurl {
      url = "https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${version}/SlimeVR-amd64.appimage";
      hash = "sha256-olMoz1tAjtTTAgfM5qFbFsCTKn29ni0QeXh4sbsmFMs=";
    };

    # Update glib in appimage, otherwise java will crash
    postExtract = ''
      rm $out/usr/lib/libglib-2.0.so.0
      ln -s ${glib}/lib/libglib-2.0.so.0 $out/usr/lib/libglib-2.0.so.0
    '';
  };
in
appimageTools.wrapAppImage {
  inherit name version src;

  extraPkgs = pkgs: with pkgs; [
    jdk17
  ];

  extraInstallCommands = ''
    install -m 444 -D ${src}/slimevr.desktop $out/share/applications/slimevr.desktop
    install -m 444 -D ${src}/usr/share/icons/hicolor/256x256@2/apps/slimevr.png \
      $out/share/icons/hicolor/256x256@2/apps/slimevr.png
    substituteInPlace $out/share/applications/slimevr.desktop \
      --replace 'Exec=slimevr' 'Exec=${name}'
  '';
}
