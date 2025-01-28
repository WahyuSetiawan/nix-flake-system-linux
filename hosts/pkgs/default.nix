{ pkgs, ... }: {
  flake.myPackages = {
    fvm = pkgs.callPackage ./fvm;
  };
}
