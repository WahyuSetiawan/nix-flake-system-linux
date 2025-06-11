{ config, osConfig, inputs, pkgs, ... }:
let
  username = osConfig.users.primaryUser.username;
in
{
  sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile =
    if pkgs.stdenv.isDarwin then
      "/Users/${username}/.config/sops/age/keys.txt" else
      "/home/${username}/.config/sops/age/keys.txt";


  sops.secrets.ssh_gitlab = { };
  sops.secrets.ssh_github = { };
  sops.secrets.ssh_gitlab_siber = { };
}
