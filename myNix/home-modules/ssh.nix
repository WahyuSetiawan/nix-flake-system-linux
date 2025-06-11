{ ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = "~/.ssh/ssh_gitlab_juragankoding"; # Ganti dengan path key-mu
        user = "git";
      };
    };
  };
}
