{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (import ./utils/zsh-bench.nix pkgs)
  ];
}
