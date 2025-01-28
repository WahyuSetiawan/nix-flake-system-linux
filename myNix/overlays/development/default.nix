{ inputs, ... }:

{
  flake.overlays.development = _final: prev: {
    fvm = prev.callPackage ./fvm.nix { };
  };
}
