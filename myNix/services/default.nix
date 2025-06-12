{ inputs, ... }: {

  perSystem = { lib, system, input', pkgs, config, ... }:
    let
      args = { inherit lib pkgs inputs config; };

      # prepare all files about services
      dir = "${inputs.self}/myNix/services";
      renameNames = name: builtins.replaceStrings [ ".nix" ] [ "" ] name;
      allServices = inputs.self.util.filesIntoMap {
        inherit dir lib;

        args = args;
        renameKey = renameNames;
        transform = (path: args:
          (pc: import path (args // { inherit pc; }))
        );
      };
    in
    {
      process-compose = allServices;
    };
}
