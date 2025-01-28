{ self, config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    callPackage import ../pkgs/fvm
  ];
}
