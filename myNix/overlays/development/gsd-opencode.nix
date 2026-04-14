{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  npmDeps,
}:

let
  version = "1.33.1";
in
stdenv.mkDerivation {
  pname = "gsd-opencode";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/gsd-opencode/-/gsd-opencode-${version}.tgz";
    sha256 = "1v3d8km51da1xnsadvvrczsz88qd3vsbxcy02zjc4adlasyx1bmd";
  };

  nativeBuildInputs = [ nodejs ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r package $out/lib
    chmod +x $out/lib/package/bin/*
    ln -s $out/lib/package/bin/gsd.js $out/bin/gsd-opencode
    ln -s $out/lib/package/bin/gsd-install.js $out/bin/gsd-install
  '';

  meta = with lib; {
    description = "GSD-OpenCode distribution manager";
    homepage = "https://github.com/rokicool/gsd-opencode";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
