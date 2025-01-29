{ inputs, ... }:

{
  flake.overlays.development = _final: prev: {
    fvm = prev.callPackage ./fvm.nix { };
    zsh-bench = prev.callPackage ./zsh-bench.nix { };
  };
}
