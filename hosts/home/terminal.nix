{ pkgs, ... }: {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.8;
          startup_mode = "Windowed";
          title = "Juragan Koding";
          blur = true;
          padding = { x = 5; y = 5; };
        };
        font = {
          size = 8;
          normal = {
            family = "MesloLGLDZNerdFont";
            style = "Regular";
          };
        };
      };
    };

    kitty = {
      enable = true;
    };

    # ghostty = {
    #   enable = true;
    # };
  };
}
