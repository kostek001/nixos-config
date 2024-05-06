{ stdenv, fetchFromGitHub, lib, cmake, qt6, kdePackages, pkgs, pkg-config }:

let
  wallpaper-scene-renderer = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-scene-renderer";
    rev = "eeaff7036526c87cb7dd46c849a5e9bd8e26e5f7";
    hash = "sha256-Bo7Q+UKD5iTzfYyuXd5hc+8jCmsCoQXBSLTCdWNU7Zc=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation rec {
  pname = "wallpaper-engine-kde-plugin";
  version = "96230de92f1715d3ccc5b9d50906e6a73812a00a";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = pname;
    rev = version;
    hash = "sha256-vkWEGlDQpfJ3fAimJHZs+aX6dh/fLHSRy2tLEsgu/JU=";
    fetchSubmodules = true;
  };

  patches = [ ./cmake.patch ];

  cmakeFlags = [
    "-DQT_MAJOR_VERSION=6"
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    kdePackages.extra-cmake-modules
    pkg-config
  ];

  # postPatch = ''
  #   rm -r src/backend_scene
  #   ln -s ${wallpaper-scene-renderer} src/backend_scene
  # '';

  propagatedBuildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwebsockets
    qt6.qtwebchannel

    vulkan-headers
    (pkgs.python3.withPackages (p: with p; [
      websockets
    ]))
    mpv
    libass
    lz4
    fribidi
  ] ++ (with kdePackages; [
    libplasma
    kdeclarative
    qt5compat
    plasma5support
    kirigami
    kcoreaddons
  ]);
  strictDeps = true;
}
