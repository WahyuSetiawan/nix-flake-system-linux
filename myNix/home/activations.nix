{ config, pkgs, ... }:
let
  homePathConfig = config.home.user-info.nixConfigDirectory;
in
{
  home.activation.stowConfig = config.lib.dag.entryAfter [ "writeBoundary" ] #bash
    ''
      echo "Running stow to symlink configuration files..."

      echo "Setting configuration nvim with stow"
      ln -sf ${homePathConfig}/dotfiles/.config/nvim $HOME/.config/nvim
      ln -sf ${homePathConfig}/dotfiles/.config/rofi $HOME/.config/rofi
    '';
}
