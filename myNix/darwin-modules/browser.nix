{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.vivaldi-dmg
  ];

  # programs.vivaldi = {
  #   enable = true;
  #   extensions = [
  #     "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
  #     "laameccjpleogmfhilmffpdbiibgbekf" # Tab suspender
  #     "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  #   ];
  # };
}
