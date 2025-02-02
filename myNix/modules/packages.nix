{ self, config, pkgs, lib, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    fantasque-sans-mono
    nerd-fonts.symbols-only
  ];


  environment.systemPackages = with pkgs; [
  ];
}
