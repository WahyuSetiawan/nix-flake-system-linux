{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = config.sops.secrets."ssh_gitlab".path; # Ganti dengan path key-mu
        user = "git";
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        identityFile = config.sops.secrets."ssh_github".path;
        user = "git";
        identitiesOnly = true;
      };
      "gitlab.digitalsiber.id" = {
        hostname = "gitlab.digitalsiber.id";
        identityFile = config.sops.secrets."ssh_gitlab_siber".path;
        user = "git";
        identitiesOnly = true;
      };
      "sentra.github.com" = {
        hostname = "github.com";
        identityFile = config.sops.secrets."ssh_github_sentra".path;
        user = "git";
        identitiesOnly = true;
      };
      "vps-akademik" = {
        hostname = "172.236.149.175";
        identityFile = config.sops.secrets."ssh_vps_akademik_user".path;
        user = "root";
        identitiesOnly = true;
      };
      "vps-spada" = {
        hostname = "172.237.79.206";
        identityFile = config.sops.secrets."ssh_vps_spada".path;
        user = "root";
        identitiesOnly = true;
      };
      "vps-spada-2" = {
        hostname = "139.162.8.27";
        identityFile = config.sops.secrets."ssh_vps_spada".path;
        user = "root";
        identitiesOnly = true;
      };
      "vps-prod-user" = {
        hostname = "172.104.54.229";
        identityFile = config.sops.secrets."ssh_vps_spada".path;
        user = "syamil";
        identitiesOnly = true;
      };
    };
  };
}
