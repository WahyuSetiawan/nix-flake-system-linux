{ inputs, system, pkgs, ... }:
with pkgs;
mkShell {
  packages = [
    php82
    php82Packages.composer
    nodejs
    nodePackages.pnpm
  ];

  shellHook = #bash
    ''
      echo "Active dev for laravel project"
    '';

}
