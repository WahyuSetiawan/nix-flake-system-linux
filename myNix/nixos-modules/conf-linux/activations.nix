{ ... }: {
  system.activationScripts = {
    keychronk2fix.text =
      ''
        # Fix for the f-keys of the Keychron K2:
        echo 0 | tee /sys/module/hid_apple/parameters/fnmode >/dev/null
      '';
  };
}
