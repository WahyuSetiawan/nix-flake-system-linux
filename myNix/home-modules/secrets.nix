{ config, osConfig, inputs, ... }:
let
  username = osConfig.users.primaryUser.username;
in
{
  sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

  sops.secrets.ssh_gitlab = { };
  sops.secrets.ssh_github = { };
  sops.secrets.ssh_gitlab_siber = { };
}
