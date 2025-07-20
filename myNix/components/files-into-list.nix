{ lib
, dir ? ./.
, args ? null
, renameKey ? (name: name)
, transform ? null
, ...
}:
let
  defaultImport = path: args: (import path args);
  defaultRenameKey = name: name;

  finalTransform = if transform != null then transform else defaultImport;
  finalRenameKey = if renameKey != null then renameKey else defaultRenameKey;

  listFilesNix = import ./files-to-list.nix { inherit lib dir; };
  listFiles = lib.foldl'
    (acc: name:
      acc ++ (import (dir + "/${name}") args)
    ) # accumulator
    [ ] # initial accumulator
    (lib.attrNames listFilesNix); # list of file names
in
listFiles
