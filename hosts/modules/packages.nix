{ self, config, pkgs, lib, ... }:
let
  myPkgs = self.myPackages;
in
{
  environment.systemPackages = with pkgs; [
    (import ./utils/zsh-bench.nix pkgs)
    myPkgs.fvm
  ];
}
