{ config, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = config.sops.secrets."ssh_gitlab".path; # Ganti dengan path key-mu
        user = "git";
      };
      "github.com" = {
        hostname = "github.com";
        identityFile = config.sops.secrets."ssh_github".path;
        user = "git";
      };
      "gitlab.digitalsiber.id" = {
        hostname = "gitlab.digitalsiber.id";
        identityFile = config.sops.secrets."ssh_gitlab_siber".path;
        user = "git";
      };
    };
  };
}
