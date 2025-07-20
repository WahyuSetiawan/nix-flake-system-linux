{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    virtualbox
  ];

  virtualisation.docker.enable = true;
}
