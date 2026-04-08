{ pkgs, ... }:
with pkgs;
[
  # Wrap postman to fix sandbox issues
  (writeShellScriptBin "postman" ''
    exec ${postman}/bin/postman --no-sandbox "$@"
  '')

  dbeaver-bin
  # zed-editor
  # zed-zed-editor
  beekeeper-studio

  (writeShellScriptBin "brave" ''
    exec ${brave}/bin/brave --no-sandbox "$@"
  '')
]
++ (
  if pkgs.stdenv.isLinux then
    [
      deskflow

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
