args'@ { ... }: {
  imports = [
    ../services/default.nix
  ];

  perSystem = all@{ pkgs, ... }:
    let
      inherit (args') inputs;

      args = { inherit inputs; inherit (all) pkgs system; };

      # prepare all files about devShell
      dir = "${inputs.self}/myNix/devShell";
      allfile = inputs.self.util.filesIntoMap {
        inherit dir; inherit (args') lib;
        args = args // { inherit pkgs; };
        renameKey = (name:
          builtins.replaceStrings [ "dev-" ".nix" ] [ "" "" ] name);
      };
    in
    {
      devShells = allfile;
    };
}

