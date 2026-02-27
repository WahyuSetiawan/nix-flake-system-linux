{
  config,
  osConfig ? null,
  inputs,
  pkgs,
  ...
}:
let
  username =
    if osConfig != null && osConfig ? users && osConfig.users ? primaryUser then
      osConfig.users.primaryUser.username
    else
      config.home.username;
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
  # Keep the age key in the standard sops location on all platforms.
  # sops.age.keyFile = "${home}/.config/sops/age/keys.txt";

  # Debug: Print the age key file location
  sops.secrets.ssh_gitlab = { };
  sops.secrets.ssh_github = { };
  sops.secrets.ssh_gitlab_siber = { };
  sops.secrets.ssh_github_sentra = { };
  sops.secrets.ssh_vps_akademik_user = { };
  sops.secrets.ssh_vps_spada = { };
  sops.secrets.ssh_vps_prod = { };
}


