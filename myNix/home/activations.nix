{ config, pkgs, ... }: {
  home.activation.stowConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Running stow to symlink configuration files..."

    echo "Setting configuration nvim with stow"
    ln -sf $HOME/nix/dotfiles/.config/sketchybar $HOME/.config/sketchybar
    ln -sf $HOME/nix/dotfiles/.config/nvim $HOME/.config/nvim
  '';
}
