{ lib
, dir ? ./.
, args ? null
, ...
}:
let
  contenxt = builtins.readDir dir;

  list = lib.filterAttrs
    (name: type:
      type == "regular" && lib.strings.hasSuffix ".nix" name && name != "default.nix")
    contenxt;

  renameKey = name: value:
    name;

  renamed = lib.mapAttrs renameKey list;
in
renamed
