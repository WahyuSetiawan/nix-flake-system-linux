{ inputs, ... }:
{
  imports = [
    ./development
  ];

  flake.overlays.default = final: prev: {
    fvm = prev.callPackage ./development/fvm.nix { };
  };
}

