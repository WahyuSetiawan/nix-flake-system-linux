{ ... }: {
  flake.util = {
    filesToNix = import ./files-to-list.nix;
    filesConcatMap = import ./import-into-map.nix;
    filesIntoMap = import ./files-into-map.nix;
    filesIntoList = import ./files-into-list.nix;
    getEnv = import ./get-env.nix;
  };
}
