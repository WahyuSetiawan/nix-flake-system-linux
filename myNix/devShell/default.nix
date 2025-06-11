args'@ { ... }: {
  imports = [
    ../services/default.nix
  ];

  perSystem = all@{ pkgs, ... }:
    let
      args = { inherit (args') inputs; inherit (all) pkgs system; };
      dir = "${args'.inputs.self}/myNix/devShell";
      allfile = args'.inputs.self.util.filesIntoMap {
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

