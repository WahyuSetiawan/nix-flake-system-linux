{ tgt, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (tgt.packages.${system}.default)
    lazygit
    w3m
    btop
  ];
}
