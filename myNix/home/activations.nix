{ ... }: {
  system.activationScripts.restartWaybar.text = ''
    systemctl --user restart waybar
  '';
}
