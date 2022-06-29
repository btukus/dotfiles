local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost install_plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
	profile = { enable = true, threshold = 1 },
})

local currentTheme = "darkplus.nvim"

function get_setup(name)
	return string.format('require("plugins/%s")', name)
end

return packer.startup(function(use)
	-- Neovim Config
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "lewis6991/impatient.nvim", config = get_setup("impatient") })
	-- use { "famiu/nvim-reload", config = get_setup("nvim-reload") }

	-- Window and session management
	use({ "ThePrimeagen/harpoon" })
	use({
		"akinsho/toggleterm.nvim",
		opt = true,
		cmd = { "ToggleTerm" },
		config = get_setup("toggleterm"),
	})
	use({ "anuvyklack/hydra.nvim", config = get_setup("hydra") })
  use { 'folke/trouble.nvim', opt = true, cmd = { 'TroubleToggle'} }

	-- Text Editing
	use({ "numToStr/Comment.nvim", event = "CursorMoved", config = get_setup("comment") })
	use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "Comment.nvim" })
	use({ "windwp/nvim-autopairs", after = "nvim-cmp", config = get_setup("autopairs") })
	use({ "windwp/nvim-ts-autotag" })

	-- Buffer Plugins
	use({ "moll/vim-bbye", opt = true, cmd = { "Bdelete" } })

	-- UI
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "lukas-reineke/indent-blankline.nvim", event = "BufRead", config = get_setup("indentline") }) -- Adds indentation lines on blank lines
	use({ "goolord/alpha-nvim", config = get_setup("alpha") })
	use({
		"kyazdani42/nvim-tree.lua",
		opt = true,
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = get_setup("nvim-tree"),
	})
	use({ "nvim-lualine/lualine.nvim", after = currentTheme, event = "BufWinEnter", config = get_setup("lualine") }) -- Statusline plugin
	-- use({
	-- 	"KadoBOT/nvim-spotify",
	-- 	opt = true,
	-- 	cmd = { "Spotify" },
	-- 	config = get_setup("nvim-spotify"),
	-- 	run = "make",
	-- })

	-- Colorschemes
	use({ "lunarvim/darkplus.nvim" })
	-- use({ "ful1e5/onedark.nvim" })
	-- use { "arcticicestudio/nord-vim" }
	-- use { "jacoborus/tender.vim" }

	-- Git
	use({ "akinsho/git-conflict.nvim", config = get_setup("git-conflict") })
	use({ "ThePrimeagen/git-worktree.nvim", after = "telescope.nvim", config = get_setup("git-worktree") })
	use({ "sindrets/diffview.nvim", opt = true, cmd = { "DiffviewOpen" } })

	-- Cmp Plugins
	use({ "hrsh7th/nvim-cmp", event = "InsertEnter", config = get_setup("cmp") })
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
	use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
	use({ "tzachar/cmp-tabnine", after = "nvim-cmp", run = "./install.sh", config = get_setup("tabnine") })
	use({ "L3MON4D3/LuaSnip", event = "InsertEnter" })
	use({ "rafamadriz/friendly-snippets", event = "InsertEnter" })

	-- LSP
	use({ "neovim/nvim-lspconfig", config = get_setup("lsp") })
	use({ "williamboman/nvim-lsp-installer" })
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({ "RRethy/vim-illuminate", config = get_setup("illuminate") })
	use({ "mfussenegger/nvim-jdtls", event = "BufWinEnter" })

	-- Telescope
	use({
		'nvim-telescope/telescope.nvim',
		opt = true,
		cmd = { 'Telescope' },
		config = get_setup('telescope'),
	})
	use({ 'nvim-telescope/telescope-fzf-native.nvim', run = "make" })
	use({ 'nvim-telescope/telescope-file-browser.nvim' })
	use({ 'nvim-telescope/telescope-project.nvim' })
  use { 'nvim-telescope/telescope-ui-select.nvim' }

	-- Treesitter
	use({ 'nvim-treesitter/nvim-treesitter', config = get_setup('treesitter') })
	use({ 'lewis6991/spellsitter.nvim', config = get_setup('spellsitter') })

	-- Debugger
	use({
		'mfussenegger/nvim-dap',
		opt = true,
		cmd = { "DapToggleBreakpoint" },
		config = get_setup("dap"),
	})
	use({ "rcarriga/nvim-dap-ui", after = "nvim-dap" })
	use({ "ravenxrz/DAPInstall.nvim", after = "nvim-dap" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
