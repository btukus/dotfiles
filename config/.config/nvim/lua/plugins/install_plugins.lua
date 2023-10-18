local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
    install_path, })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost install_plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
  profile = { enable = true, threshold = 1 },
})

function get_setup(name)
  return string.format('require("plugins/%s")', name)
end

return packer.startup(function(use)
  -- Neovim Config
  use({ "wbthomason/packer.nvim" })
  use({ "nvim-lua/plenary.nvim" })
  use({ "lewis6991/impatient.nvim", config = get_setup("impatient") })
  use({ "aserowy/tmux.nvim", event = "BufWinEnter", config = get_setup("tmux") })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "MunifTanjim/nui.nvim" })
  use({ "folke/noice.nvim", event = "BufWinEnter", config = function() require("noice").setup({}) end })
  use({ 'fgheng/winbar.nvim', event = "BufWinEnter", config = get_setup("winbar") })
  --[[ use({ "nanozuki/tabby.nvim", event = "BufWinEnter", config = function() require("tabby").setup({}) end}) ]]
  use({ 'romgrk/barbar.nvim', requires = { 'lewis6991/gitsigns.nvim' },
    config = function() require("barbar").setup({}) end })
  use {"shortcuts/no-neck-pain.nvim", tag = "*" }

  -- Motion
  use({ "ggandor/leap.nvim", config = get_setup("leap"), opt = true, keys = { "s" } })
  use({ "chaoren/vim-wordmotion" })
  use({ "karb94/neoscroll.nvim", event = "BufWinEnter", config = function() require("neoscroll").setup({}) end })

  -- Window and session management
  use({ "simrat39/symbols-outline.nvim", opt = true, cmd = { "SymbolsOutline" }, config = get_setup("symbols_outline"), })
  use({ "folke/trouble.nvim", opt = true, cmd = { "TroubleToggle" } })

  -- Text Editing
  use({ "numToStr/Comment.nvim", opt = true, keys = { "gc", "gcc", "gbc" }, config = get_setup("comment"), })
  use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "Comment.nvim" })
  use({ "windwp/nvim-autopairs", event = "BufWinEnter", config = get_setup("autopairs") })
  use({ "windwp/nvim-ts-autotag", event = "BufWinEnter" })
  use({ "kylechui/nvim-surround", event = "BufWinEnter", config = get_setup("nvim-surround") })
  use({ 'Wansmer/treesj', opt = true, cmd = { "TSJToggle" }, config = function() require('treesj').setup({}) end, })
  use({ "nguyenvukhang/nvim-toggler", config = get_setup("nvim-toggler") })

  -- Buffer Plugins
  use({ "moll/vim-bbye", opt = true, cmd = { "Bdelete" } })
  use({ "ethanholz/nvim-lastplace", config = get_setup("lastplace") })
  use({ "lukas-reineke/indent-blankline.nvim", config = get_setup("indentline") })
  -- use({ "lukas-reineke/indent-blankline.nvim", config = function () require("ibl").setup() end })

  -- Colorschemes
  use { "ful1e5/onedark.nvim" }
  use({ "projekt0n/github-nvim-theme" })

  -- Git
  use({ "akinsho/git-conflict.nvim", tag = "*", config = get_setup("git-conflict") })
  use({ "ThePrimeagen/git-worktree.nvim", config = get_setup("git-worktree") })
  use({ "sindrets/diffview.nvim", opt = true, cmd = { "DiffviewOpen" } })
  use({ "kdheepak/lazygit.nvim" })

  -- LSP
  use { 'VonHeikemen/lsp-zero.nvim', config = get_setup("lsp-zero"), requires = {
    --
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },
  } }
  use { "zbirenbaum/copilot.lua", event = "BufWinEnter", config = get_setup("copilot") }
  use { 'akinsho/flutter-tools.nvim', config = function() require("flutter-tools").setup({}) end,
    requires = { 'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim', } }

  -- Telescope
  use({ "nvim-telescope/telescope.nvim", opt = true, cmd = { "Telescope" }, config = get_setup("telescope") })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  use({ "ahmedkhalf/project.nvim", config = get_setup("project") })
  use({ "ANGkeith/telescope-terraform-doc.nvim" })

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", config = get_setup("treesitter") })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
