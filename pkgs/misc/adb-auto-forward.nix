{ python3Packages
, fetchFromGitHub
, android-tools
}:

python3Packages.buildPythonApplication rec {
  pname = "adb-auto-forward";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kostek001";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KNi1mKA7ywskVLVbyMHjrPbcxoIbCnbguP+HnjhQ/Cg=";
  };

  dependencies = with python3Packages; [
    pyudev
  ];

  buildInputs = [ android-tools ];

  doCheck = false;
}
