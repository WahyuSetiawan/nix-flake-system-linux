{ ... }: {
  programs.git = {
    enable = true;
    userName = "Wahyu Setiawan"; # Ganti dengan nama Git kamu
    userEmail = "wahyu.creator911@gmail.com"; # Ganti dengan email Git kamu
    extraConfig = {
      core.editor = "nvim";
    };
  };
}
