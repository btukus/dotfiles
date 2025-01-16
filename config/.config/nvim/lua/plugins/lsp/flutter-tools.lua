return {
  'akinsho/flutter-tools.nvim',
  lazy = true,
  keys = {
    { 'n', '<leader>fq', ':FlutterRun<CR>', { noremap = true, silent = true } },
    { 'n', '<leader>fQ', ':FlutterQuit<CR>', { noremap = true, silent = true } },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  config = true,
  enabled = false,
}
