{lib, dir ? ./.,args ? null, ...}:let
  listFilesNix = import ./files-to-list.nix { inherit lib dir;};
    mapFiles = lib.foldl'
    (acc: name:
      acc // (import (dir + "/${name}") args)
    )
    { }
    (lib.attrNames listFilesNix);

in mapFiles
