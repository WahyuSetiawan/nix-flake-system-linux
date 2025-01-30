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
  ];

  perSystem = { lib, system, input', ... }:
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
              vim curl
              neovim
              wget
              git
              ;
          };
        };
    };
}
