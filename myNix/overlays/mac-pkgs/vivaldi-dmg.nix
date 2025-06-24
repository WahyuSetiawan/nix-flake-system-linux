{
  lib,
  stdenv,
  fetchurl,
  undmg,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "vivaldi-dmg";

  version = "7.4.3684.55";
  sha256 = "sha256-g7ZfnV8vXSwYPYeSW/4bkackLVmTdH7a3TB5aOdMuTg=";

  srcs =
    let
      base = "https://downloads.vivaldi.com/stable";
    in
    rec {
      aarch64-darwin = {
        url = "${base}/Vivaldi.${version}.universal.dmg";
        sha256 = sha256;
      };
      x86_64-darwin = aarch64-darwin;
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "Browse the internet citizen";
    homepage = "https://vivaldi.com/id/";
    license = licenses.mit;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Vivaldi.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Vivaldi.app
      cp -R . $out/Applications/Vivaldi.app
      runHook postInstall
    '';
  };
in
darwin
