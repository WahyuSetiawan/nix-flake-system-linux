{ config, pkgs, ... }: {
  users.defaultUserShell = pkgs.zsh;
  users.users.juragankoding = {
    isNormalUser = true;
    description = "Juragan Koding";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

}
