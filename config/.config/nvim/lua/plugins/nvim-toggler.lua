local status_ok, toggler = pcall(require, "nvim-toggler") if not status_ok then return end

toggler.setup({
  -- your own inverses
  inverses = {
    ['vim'] = 'emacs',
    ['evet'] = 'hayir',
    ['ja'] = 'nee'
  },
  -- removes the default <leader>i keymap
  remove_default_keybinds = false,
  -- removes the default set of inverses
  remove_default_inverses = false,
})
