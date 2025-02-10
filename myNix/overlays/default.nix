{ inputs, ... }:
{
  imports = [
    ./development
    ./nodePackages
    ./mac-pkgs
  ];

  flake.overlays.default = final: prev: {
    fvm = prev.callPackage ./development/fvm.nix { };

    vivaldi = prev.vivaldi.overrideAttrs (old: {
      postInstall = old.postInstall or "" + ''
        sed -i 's|Exec=.*|Exec=${old.passthru.wrapperPath or "/run/current-system/sw/bin/vivaldi"} --ozone-platform=x11 %U|' $out/share/applications/vivaldi-stable.desktop
      '';
    });

    sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "sf-mono-liga-bin";
      version = "7723040ef50633da5094f01f93b96dae5e9b9299";

      src = prev.fetchFromGitHub {
        owner = "shaunsingh";
        repo = "SFMono-Nerd-Font-Ligaturized";
        rev = finalAttrs.version;
        sha256 = "sha256-vPUl6O/ji4hHIH7/qSbUe7q1QdugE1D1ZRw92QcSSDQ=";
      };

      dontConfigure = true;
      installPhase = ''
        mkdir -p $out/share/fonts/opentype
        cp -R $src/*.otf $out/share/fonts/opentype
      '';
    });

    sketchybar-app-font = prev.stdenv.mkDerivation {
      name = "sketchybar-app-font";
      src = inputs.sketchybar-app-font;
      buildInputs = [
        final.nodejs
        final.nodePackages.svgtofont
      ];
      buildPhase = ''
        ln -s ${final.nodePackages.svgtofont}/lib/node_modules ./node_modules
        node ./build.js
      '';
      installPhase = ''
        mkdir -p $out/share/fonts
        cp -r dist/*.ttf $out/share/fonts
      '';
    };
  };
}

