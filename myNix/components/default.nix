{ ... }: {
  flake.util = {
    filesToNix = import ./files-to-list.nix;
    filesConcatMap = import ./import-into-map.nix;
    filesIntoMap = import ./import-into-map.nix;
  };
}
