{ self
, lib
, inputs
, ...
}: {
  imports = [
    ./modules
    ./home
    ./hosts
    ./overlays
    ./devShell.nix
    ./devShell
    ./services
  ];

  perSystem = { lib, system, input', pkgs, ... }:
    {
      _module.args =
        let
          selfOverlays = lib.attrValues self.overlays;
          overlays = [ ] ++ selfOverlays;
        in
        rec {
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
            };

            hostPlatform = system;
            inherit overlays;
          };

          pkgs = import inputs.nixpkgs {
            inherit system;
            inherit (nixpkgs) config;
            inherit overlays;
          };

          basePackageFor = pkgs: builtins.attrValues {
            inherit (pkgs)
              vim
              curl
              wget
              git
              ;
          };
        };
    };
}
