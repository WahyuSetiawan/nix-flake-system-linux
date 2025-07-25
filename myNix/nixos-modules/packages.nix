{ pkgs, ... }: {
  imports = [
    ./packages-flutter-dev.nix
  ];

  environment.systemPackages = with pkgs ;[
    xdg-desktop-portal
    home-manager
    vimPlugins.fzfWrapper

    # tools utils
    libva
    libva-utils

    # development
    kdePackages.kde-gtk-config
  ];

  environment.variables = rec{
    FVM_CACHE_PATH = "$HOME/.fvm";
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    PATH = [
      "${FVM_CACHE_PATH}/default/bin"
    ];
  };

  # programs = {
  #   avd = true;
  # };

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

}
