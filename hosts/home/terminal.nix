{ pkgs, ... }: {
  programs = {
    alacritty = {
      enable = true;
    };

    kitty = {
      enable = true;
    };

    # ghostty = {
    #   enable = true;
    # };
  };
}
