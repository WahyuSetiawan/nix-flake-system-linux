{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Wahyu Setiawan"; # Ganti dengan nama Git kamu
        email = "wahyu.creator911@gmail.com"; # Ganti dengan email Git kamu
      };
      core = {
        editor = "nvim";
      };
    };
  };
}
