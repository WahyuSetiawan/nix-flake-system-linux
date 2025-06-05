{ pkgs, ... }: {
  environment.systemPackages = with pkgs ;[
    wpsoffice
  ];
}
