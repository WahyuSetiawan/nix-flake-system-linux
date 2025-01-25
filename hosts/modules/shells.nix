{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    zsh
  ];

  programs = {
    zsh = {
      enable = true;
    };
  };
}
