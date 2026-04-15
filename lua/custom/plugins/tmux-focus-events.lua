-- Map tmux pane focus sequences (\e[O / \e[I) to FocusLost / FocusGained.
-- Use the upstream plugin when native focus events do not reach Neovim inside tmux.
-- Requires `set -g focus-events on` in tmux.conf.
return {
  {
    'tmux-plugins/vim-tmux-focus-events',
    lazy = false,
    priority = 1000,
  },
}
