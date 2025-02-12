{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (inputs.tgt.packages.${system}.default)
    lazygit
    w3m
    btop
  ];
}
