{ ... }: { pkgs, inputs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { };

  home-manager.sharedModules =
    if pkgs.stdenv.isDarwin then [
      inputs.mac-app-util.homeManagerModules.default
    ] else [ ];
}
