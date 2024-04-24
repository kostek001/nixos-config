{ buildFHSEnv, fetchzip }:
let
  name = "alvr";
  version = "20.7.1";

  src = fetchzip {
    url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/alvr_streamer_linux.tar.gz";
    hash = "sha256-XlTUgk+Cmt8jLsQOG0WLPv+COYUCimvADa6sJ1AIncY=";
  };
in
buildFHSEnv {
  inherit name;

  targetPkgs = pkgs: (with pkgs; [
    ffmpeg
    libva
    alsa-lib
    egl-wayland
    libxkbcommon
    libGL
    wayland
  ]);

  runScript = "${src}/bin/alvr_dashboard";
}
