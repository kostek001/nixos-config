{ lib, fetchFromGitHub, rustPlatform, pkgs }:

rustPlatform.buildRustPackage rec {
  pname = "alvr";
  version = "20.7.1";

  src = fetchFromGitHub {
    owner = "alvr-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-znIRSax4thuBIpxW8BNqJSUYgIeY8g06qA9P/i8awvQ=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  # cargoHash = lib.fakeHash;
  # cargoDepsName = pname;

  nativeBuildInputs = with pkgs; [ pkg-config ];

  buildInputs = with pkgs; [
    libjack2
    alsa-lib
  ];

  meta = with lib; {
    description = "ALVR";
    homepage = "https://github.com/alvr-org/ALVR";
    license = licenses.mit;
    maintainers = [];
  };
}