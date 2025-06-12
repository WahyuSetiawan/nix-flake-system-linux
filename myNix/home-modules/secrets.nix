{ config, osConfig, inputs, pkgs, ... }:
let
  username = osConfig.users.primaryUser.username;
  home = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${home}/.config/sops/age/keys.txt";

  sops.secrets.ssh_gitlab = { };
  sops.secrets.ssh_github = { };
  sops.secrets.ssh_gitlab_siber = { };
}
