{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    zsh
    fish
  ];

  programs = {
    zsh = {
      enable = true;
    };
    fish = {
      enable = true;
    };
  };
}
