{ lib, dir ? ./., args ? null, renameKey ? (name: name), ... }:
let
  defaultRenameKey = name: name;
  finalRenameKey= if renameKey != null then renameKey else defaultRenameKey;

  listFilesNix = import ./files-to-list.nix { inherit lib dir; };
  mapFiles = lib.foldl'
    (acc: name:
      acc // {
        ${finalRenameKey name} = (import (dir + "/${name}") args);
      }
    )
    { }
    (lib.attrNames listFilesNix);
in
mapFiles
