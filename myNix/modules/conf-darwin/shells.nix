{ pkgs, config, ... }: {
  # babelfishPackage = pkgs.babelfish;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  # shellInit = # fish
  #   ''
  #     for p in (string split : ${config.environment.systemPath})
  #       if not contains $p $fish_user_paths
  #         set -g fish_user_paths $fish_user_paths $p
  #       end
  #     end
  #   '';
}
