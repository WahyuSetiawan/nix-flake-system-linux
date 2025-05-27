{ pkgs, ... }: {
  environment = with pkgs;{
    systemPackages = [
      fish
    ];

    variables = {
      SHELL = "${fish}/bin/fish";
      # CC = "${gcc}/bin/gcc";
    };
  };

  programs = {
    fish = {
      enable = true;
      useBabelfish = true;
    };
  };

}
