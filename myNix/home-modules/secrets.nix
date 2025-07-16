{ config, osConfig, inputs, pkgs, ... }:
let
  username = osConfig.users.primaryUser.username;
  home = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile =
    if pkgs.stdenv.isDarwin then
      "${home}/Library/Application Support/sops/age/keys.txt"
    else
      "${home}/.config/sops/age/keys.txt";

  sops.secrets.ssh_gitlab = { };
  sops.secrets.ssh_github = { };
  sops.secrets.ssh_gitlab_siber = { };
  sops.secrets.ssh_github_sentra = { };
  sops.secrets.ssh_vps_akademik_user = { };
}
