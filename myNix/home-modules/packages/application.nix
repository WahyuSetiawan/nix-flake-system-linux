{ pkgs, ... }:
with pkgs;
[
  # Wrap postman to fix sandbox issues
  (writeShellScriptBin "postman" ''
    exec ${postman}/bin/postman --no-sandbox "$@"
  '')

  # (writeShellScriptBin "antares" ''
  #   exec ${antares}/bin/antares --no-sandbox "$@"
  # '')

  dbeaver-bin
  zed-editor
]
++ (
  if pkgs.stdenv.isLinux then
    [
      # Linux-specific applications
      nemo
      gnome-calculator
      gnome-screenshot
      gnome-system-monitor
      gnome-tweaks
      gnome-font-viewer
      gnome-characters
    ]
  else
    [ ]
)
