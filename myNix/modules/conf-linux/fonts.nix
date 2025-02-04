{ pkgs, ... }: {
  services.xserver.dpi = 96;
  fonts = {
    enableDefaultPackages = true;
    fonts = with pkgs;{ };


    fontconfig = {
      enable = true;
      antialias = true; # Aktifkan antialiasing
      hinting = {
        enable = true; # Aktifkan hinting
        style = "hintslight"; # Gaya hinting
      };
      subpixel = {
        lcdfilter = "default"; # Filter subpixel
        rgba = "rgb"; # Susunan subpixel
      };
      defaultFonts = { };
    };
  };

}
