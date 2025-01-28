{ self, inputs, ... }: {
  imports = [
    ./modules
    ./home
    ./hosts
    ./pkgs
  ];

  perSystem = { lib, system, input', ... }: {
    _module.args = {
      nixpkgs = {
        config = lib.mkForce {
          allowBroken = true;
          allowUnfree = true;
          tarball-ttl = 0;
        };

        hostPlatform = system;
      };
    };
  };
}
