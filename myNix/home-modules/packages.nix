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
    packages = import inputs.nixgl { inherit pkgs; };
    defaultWrapper = "nvidiaPrime";
    offloadWrapper = "nvidiaPrime";
    installScripts = [ "mesa" "nvidiaPrime" ];
  };

  home.packages = with pkgs; listPackages ++ [
    # development
    killall
    xclip

    lua-language-server
    inputs.oxalica-nil.packages.${pkgs.system}.nil

    nodejs
  ] ++ (if pkgs.stdenv.isLinux then [

    arandr
    wl-clipboard
  ] else [ ]);

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
    GOPATH = "${pkgs.go}/share/go";
  };

}
