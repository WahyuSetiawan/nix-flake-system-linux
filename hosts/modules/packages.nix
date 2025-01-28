{ config, pkgs, lib, ... }:
let
  fvm = pkgs.callPackage ./utils/fvm { };
in
{
  environment.systemPackages = with pkgs; [
    (import ./utils/zsh-bench.nix pkgs)
    fvm
  ];
}
