{ self
, lib
, inputs
, ...
}: {
  imports = [
    ./modules
    ./home
    ./hosts
    ./pkgs
    ./overlays
  ];

  perSystem = { lib, system, input', ... }:
    {
      _module.args =
        let
          overlays = [ ] ++ lib.attrValues self.overlays;
        in
        rec {

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

            overlays = lib.mkForce overlays;
          };

          pkgs = import inputs.nixpkgs {
            inherit system;
            inherit (nixpkgs) config;
            inherit overlays;
          };
        };
    };
}
