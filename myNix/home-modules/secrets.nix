{config,  osConfig, ... }:
let
    nixConfigDirectory = config.home.user-info.nixConfigDirectory;

  username = osConfig.users.primaryUser.username;
in
{
  sops.defaultSopsFile = "${nixConfigDirectory}/secrets/secrets.yaml"; 
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

  sops.secrets.ssh_gitlab = {
    # path = "/home/${username}/.ssh/ssh-gitlab-juragankoding";
  };
}
