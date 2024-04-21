{ stdenv, pkgs, fetchzip,
  autoPatchelfHook,
  ffmpeg,
  libva,
  alsa-lib,
  libxml2,
  libxkbcommon,
  libGL,
  wayland,
  pulseaudio
}:

stdenv.mkDerivation rec {
  pname = "alvr";
  version = "20.7.1";

  src = fetchzip {
    url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/alvr_streamer_linux.tar.gz";
    hash = "sha256-XlTUgk+Cmt8jLsQOG0WLPv+COYUCimvADa6sJ1AIncY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  propagatedBuildInputs = [
    ffmpeg
    libva
    alsa-lib
    pulseaudio
    wayland
    libxkbcommon
    libGL
    libxml2
  ];

  runtimeDependencies = [
    wayland
    libxkbcommon
    libGL
    libxml2
  ];

  installPhase = ''
    install -m755 -D bin/alvr_dashboard $out/bin/alvr
  '';
}