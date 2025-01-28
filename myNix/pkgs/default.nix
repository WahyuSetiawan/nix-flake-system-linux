{ inputs,... }: {
  flake.myPackages = {
    fvm = inputs.pkgs.callPackage ./fvm;
  };
}
