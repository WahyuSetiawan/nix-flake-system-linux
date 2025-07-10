{
  lib,
  stdenv,
  fetchurl,
  undmg,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "workfolio";

  version = "7.4.3684.55";
  sha256 = "sha256-tVmsC5zAjpryiaX4WeA8ccjVU0pUocZ3LSv9kqEJZTE=";

  srcs =
    let
      base = "https://workfolio-public.s3.ap-south-1.amazonaws.com/Workfolio+Setup.dmg";
    in
    rec {
      aarch64-darwin = {
        url = "${base}";
        sha256 = sha256;
      };
      x86_64-darwin = aarch64-darwin;
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "Getworkfolio";
    homepage = "https://www.getworkfolio.com";
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

    sourceRoot = "Workfolio.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Workfolio.app
      cp -R . $out/Applications/Workfolio.app
      runHook postInstall
    '';
  };
in
darwin
