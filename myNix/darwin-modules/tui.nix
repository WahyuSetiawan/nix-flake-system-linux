{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lazygit
    w3m
    btop
  ];
}
