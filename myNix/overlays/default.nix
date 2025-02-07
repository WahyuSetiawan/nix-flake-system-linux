{ inputs, ... }:
{
  imports = [
    ./development
  ];

  flake.overlays.default = final: prev: {
    fvm = prev.callPackage ./development/fvm.nix { };

    vivaldi = prev.vivaldi.overrideAttrs (old: {
      postInstall = old.postInstall or "" + ''
        sed -i 's|Exec=.*|Exec=${old.passthru.wrapperPath or "/run/current-system/sw/bin/vivaldi"} --ozone-platform=x11 %U|' $out/share/applications/vivaldi-stable.desktop
      '';
    });
  };
}

