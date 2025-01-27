{ pkgs, ... }: {
  programs.tmux.enable = true;
  programs.tmux.mouse = true;
  programs.tmux.newSession = true;
  programs.tmux.reverseSplit = true;
  programs.tmux.customPaneNavigationAndResize = true;
  programs.tmux.prefix = "C-a";
  programs.tmux.resizeAmount = 10;
  programs.tmux.terminal = "screen-256color";
  programs.tmux.keyMode = "vi";
  programs.tmux.extraConfig = #tmux 
    ''
      set -g activity-action other
      set -g assume-paste-time 1
      set -g base-index 0
      set -g bell-action any
      set -g default-command ""
      set -g destroy-unattached off
      set -g detach-on-destroy on
      set -g display-panes-active-colour red
      set -g display-panes-colour blue
      set -g display-panes-time 1000
      set -g display-time 750
      set -g history-limit 2000
      set -g set-clipboard external
      set -g key-table "root"
      set -g lock-after-time 0
      set -g lock-command "lock -np"
      set -g message-command-style fg=yellow,bg=black
      set -g message-style fg=black,bg=yellow
      set -g mouse on
      set -g prefix2 None
      set -g renumber-windows off
      set -g repeat-time 500
      set -g set-titles off
      set -g set-titles-string "#S:#I:#W - \"#T\" #{session_alerts}"
      set -g silence-action other

      # 0 is too far from ` ;)
      set -g base-index 1

      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on

      #set -g default-terminal screen-256color
      set -g status-keys vi
      set -g history-limit 10000

      bind-key | split-window -h
      bind-key \\ split-window -v

      bind-key J resize-pane -D 5
      bind-key K resize-pane -U 5
      bind-key H resize-pane -L 5
      bind-key L resize-pane -R 5

      bind-key M-j resize-pane -D
      bind-key M-k resize-pane -U
      bind-key M-h resize-pane -L
      bind-key M-l resize-pane -R

      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-H resize-pane -L 5
      bind -n M-L resize-pane -R 5

      set-window-option -g mode-keys vi
      # Reload tmux config
      bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"
      bind-key Z split-window -h "nvim ~/.zshrc"
      bind-key V split-window -h "cd ~/.config/nvim && nvim ~/.config/nvim"
      bind-key N split-window -h "cd ~/.config/nix && nvim ~/nix"
    '';

  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    {
      plugin = vim-tmux-navigator;
      extraConfig = #tmux
        ''
          set -g @vim_navigator_mapping_left "C-Left C-h"  # use C-h and C-Left
          set -g @vim_navigator_mapping_right "C-Right C-l"
          set -g @vim_navigator_mapping_up "C-k"
          set -g @vim_navigator_mapping_down "C-j"
          set -g @vim_navigator_mapping_prev ""  # removes the C-\ binding
          set -g @vim_navigator_prefix_mapping_clear_screen ""
        '';
    }
    # {
    #   plugin = yank;
    #   extraConfig = # tmux
    #     ''
    #       bind Enter copy-mode # enter copy mode
    #
    #       set -g @shell_mode 'vi'
    #       set -g @yank_selection_mouse 'clipboard'
    #
    #       run -b 'tmux bind -t vi-copy v begin-selection 2> /dev/null || true'
    #       run -b 'tmux bind -T copy-mode-vi v send -X begin-selection 2> /dev/null || true'
    #       run -b 'tmux bind -t vi-copy C-v rectangle-toggle 2> /dev/null || true'
    #       run -b 'tmux bind -T copy-mode-vi C-v send -X rectangle-toggle 2> /dev/null || true'
    #       run -b 'tmux bind -t vi-copy y copy-selection 2> /dev/null || true'
    #       run -b 'tmux bind -T copy-mode-vi y send -X copy-selection-and-cancel 2> /dev/null || true'
    #       run -b 'tmux bind -t vi-copy Escape cancel 2> /dev/null || true'
    #       run -b 'tmux bind -T copy-mode-vi Escape send -X cancel 2> /dev/null || true'
    #       run -b 'tmux bind -t vi-copy H start-of-line 2> /dev/null || true'
    #       run -b 'tmux bind -T copy-mode-vi H send -X start-of-line 2> /dev/null || true'
    #       run -b 'tmux bind -t vi-copy L end-of-line 2> /dev/null || true'
    #       run -b 'tmux bind -T copy-mode-vi L send -X end-of-line 2> /dev/null || true'
    #     '';
    # }
    #
    # { plugin = resurrect; }
    {
      plugin = continuum;
      extraConfig = # tmux
        ''
          set -g @resurrect-strategy-nvim 'session' 
          set -g @resurrect-capture-pane-contents 'on'
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
    }
  ];


}
