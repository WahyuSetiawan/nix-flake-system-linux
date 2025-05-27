{ inputs, lib, ... }:
let
  selfOverlays = lib.attrValues inputs.self.overlays;
  overlays = [ ] ++ selfOverlays;
in
{

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config = {
      lib.mkForce = {
        allowBroken = true;
        allowUnfree = true;
        tarball-ttl = 0;

        contentAddressedByDefault = false;

      };
      android_sdk.accept_license = true;
      allowUnfree = true;

      substituters = [
        "https://juragankoding-cachix.cachix.org" # Ganti dengan nama cache Anda
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "juragankoding-cachix.cachix.org-1:ex3UA6Mt3+flrMkn9QmtX3iv2YowKXz8704acL2uPrY=" # Ganti dengan public key Anda
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    hostPlatform = "x86_64-linux";
    inherit overlays;
  };
}
