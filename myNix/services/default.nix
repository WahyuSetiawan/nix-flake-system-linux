{ inputs, ... }: {
  perSystem = { lib, system, input', pkgs, config, ... }:
    let
      args = { inherit lib pkgs inputs config; };

      # prepare all files about services
      dir = "${inputs.self}/myNix/services";
      allServices = inputs.self.util.filesIntoMap {
        inherit dir; inherit lib;

        args = { inherit lib pkgs inputs config; };
        renameKey = (name:
          builtins.replaceStrings [ ".nix" ] [ "" ] name);
        transform = (path: args:
          (pc: import path (args // { inherit pc; }))
        );
      };
    in
    {
      process-compose = allServices;
    };
}
