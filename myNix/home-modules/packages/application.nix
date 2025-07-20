{ pkgs, ... }: with pkgs; [
  postman
] ++ (if pkgs.stdenv.isLinux then [
  # Linux-specific applications
  nemo
  gnome-calculator
  gnome-screenshot
  gnome-system-monitor
  gnome-tweaks
  gnome-font-viewer
  gnome-characters
] else [ ])
