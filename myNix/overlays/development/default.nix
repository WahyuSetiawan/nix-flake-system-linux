{ inputs, ... }:

{
  flake.overlays.development = _final: prev: {
    fvm = prev.callPackage ./fvm.nix { };
    zsh-bench = prev.callPackage ./zsh-bench.nix { };
    workfolio = prev.callPackage ./getworkfolio.nix { };
    workfolionix = prev.callPackage ./workfolio-nix.nix { };
  };
}
