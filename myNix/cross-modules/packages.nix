{ inputs, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
    fantasque-sans-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    age
    lua-language-server
    inputs.oxalica-nil.packages.${pkgs.system}.nil
  ];
}
