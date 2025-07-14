{ pkgs, lib, config, osConfig, ... }:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
  concatString' = lib.strings.concatStringsSep " && ";
  username = osConfig.users.primaryUser.username;
in
{
  # allias for nix
  nixclean = concatString' [
    "nix profile wipe-history"
    "nix-collect-garbage"
    "nix-collect-garbage -d"
    "nix-collect-garbage --delete-old"
    "nix store gc"
    "nix store optimise"
    "nix-store --verify --repair --check-contents"
  ];
  nixda = "direnv allow";
  nixdr = "direnv reload";

  nixopensecrets = "nix-shell -p sops --run \"${nixConfigDirectory}/secrets/secrets.yaml\"";

  nixhomeswitch = "home-manager switch --flake ${nixConfigDirectory}";
  nixbuild =
    if pkgs.stdenv.isDarwin
    then "sudo darwin-rebuild build --flake ${nixConfigDirectory}#${username}" else
      "nixos-rebuild build --flake ${nixConfigDirectory}#${username} --sudo";
  nixdryrun =
    if pkgs.stdenv.isDarwin
    then "sudo darwin-rebuild dry-run --flake ${nixConfigDirectory}#${username}" else
      "nixos-rebuild dry-run --flake ${nixConfigDirectory}#${username} --sudo";
  nixswitch =
    if pkgs.stdenv.isDarwin
    then "sudo darwin-rebuild switch --flake ${nixConfigDirectory}#${username}" else
      "nixos-rebuild switch --flake ${nixConfigDirectory}#${username} --sudo";

}
