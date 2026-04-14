{ pkgs, ... }:
[
  pkgs.k6
  (pkgs.writeShellScriptBin "gsd-opencode" ''
    exec ${pkgs.nodejs}/bin/npx gsd-opencode "$@"
  '')
]
