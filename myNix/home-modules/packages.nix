{ inputs, pkgs, config, lib, args, ... }:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
  dirAllias = ./packages;
  listPackages = inputs.self.util.filesIntoList {
    inherit lib;
    dir = dirAllias;
    args = { inherit inputs pkgs config; };
  };
in
{
  # nixGL configuration - only for Linux
  nixGL = lib.mkIf pkgs.stdenv.isLinux {
    packages = import inputs.nixgl { 
      inherit pkgs; 
      enable32bits = false;  # Add this to avoid some issues
    };
    defaultWrapper = "mesa";  # Change from nvidiaPrime to mesa for better compatibility
    offloadWrapper = "mesa";
    installScripts = [ "mesa" ];  # Remove nvidiaPrime for now
  };

  home.packages = with pkgs; listPackages ++ [
    # development
    killall
    xclip

    lua-language-server
    inputs.oxalica-nil.packages.${pkgs.stdenv.hostPlatform.system}.nil  # Fix system reference

    nodejs
  ] ++ (if pkgs.stdenv.isLinux then [
    arandr
    wl-clipboard

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
    nerd-fonts.meslo-lg
  ] else [ ]);

  fonts.fontconfig.enable = true;


  # Desktop entries for applications - only for Linux
  xdg.desktopEntries = lib.mkIf pkgs.stdenv.isLinux {
    postman = {
      name = "Postman";
      comment = "API Development Environment";
      exec = "postman";
      icon = "postman";
      terminal = false;
      categories = [ "Development" "Network" "WebDevelopment" ];
      mimeType = [ "application/json" ];
    };
  };

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
    GOPROXY = "https://proxy.golang.org,direct";
    GOPATH = "$HOME/go/bin";
    # GOROOT = "$HOME/go";
  };
}
