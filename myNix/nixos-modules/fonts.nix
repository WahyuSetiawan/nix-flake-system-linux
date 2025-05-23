{ pkgs, ... }: {
  services.xserver.dpi = 100;
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true; # Aktifkan antialiasing
      hinting = {
        enable = true; # Aktifkan hinting
        style = "slight"; # Gaya hinting
      };
      subpixel = {
        lcdfilter = "default"; # Filter subpixel
        rgba = "rgb"; # Susunan subpixel
      };
      defaultFonts = { };
    };
  };

}
