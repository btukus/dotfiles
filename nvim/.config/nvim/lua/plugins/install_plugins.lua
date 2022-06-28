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
	use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	use({ "lewis6991/impatient.nvim", config = get_setup("impatient") }) -- Improves startup time by implementing a cache
	-- use { "famiu/nvim-reload", config = get_setup("nvim-reload") }                 -- Reloads/restarts nvim configuration
	use({ "Pocco81/AutoSave.nvim", config = get_setup("autosave") })

	-- Window and session management
	use({ "ThePrimeagen/harpoon" })
	use({
		"akinsho/toggleterm.nvim",
		opt = true,
		cmd = { "ToggleTerm" },
		config = get_setup("toggleterm"),
	}) -- A neovim plugin to persist and toggle multiple terminals during an editing session
	use({ "anuvyklack/hydra.nvim", config = get_setup("hydra") })

	-- Text Editing
	use({ "numToStr/Comment.nvim", event = "CursorMoved", config = get_setup("comment") })
	use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "Comment.nvim" }) -- A Neovim plugin for setting the commentstring option based on the cursor location in the file. The location is checked via treesitter queries.
	use({ "windwp/nvim-autopairs", after = "nvim-cmp", config = get_setup("autopairs") }) -- Autopairs, integrates with both cmp and treesitter
	use({ "windwp/nvim-ts-autotag" })

	-- Buffer Plugins
	use({ "moll/vim-bbye", opt = true, cmd = { "Bdelete" } }) -- Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.
	use({ "matbme/JABS.nvim", opt = true, cmd = { "JABSOpen" }, config = get_setup("jabs") })

	-- UI
	use({ "kyazdani42/nvim-web-devicons" }) -- Icons
	use({ "lukas-reineke/indent-blankline.nvim", event = "BufRead", config = get_setup("indentline") }) -- Adds indentation lines on blank lines
	use({ "goolord/alpha-nvim", config = get_setup("alpha") })
	use({
		"kyazdani42/nvim-tree.lua",
		opt = true,
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = get_setup("nvim-tree"),
	}) -- File explorer tree written in lua
	use({ "nvim-lualine/lualine.nvim", after = currentTheme, event = "BufWinEnter", config = get_setup("lualine") }) -- Statusline plugin
	use({
		"KadoBOT/nvim-spotify",
		opt = true,
		cmd = { "Spotify" },
		config = get_setup("nvim-spotify"),
		run = "make",
	}) -- Spotify-tui integration

	-- Colorschemes
	use({ "lunarvim/darkplus.nvim" }) -- VScode theme
	-- use({ "ful1e5/onedark.nvim" }) -- Current default
	-- use { "arcticicestudio/nord-vim" }
	-- use { "jacoborus/tender.vim" }

	-- Git
	use({ "akinsho/git-conflict.nvim", config = get_setup("git-conflict") }) -- A plugin to visualise and resolve conflicts in neovim
	use({ "ThePrimeagen/git-worktree.nvim", after = "telescope.nvim", config = get_setup("git-worktree") })
	use({ "sindrets/diffview.nvim", opt = true, cmd = { "DiffviewOpen" } })

	-- Cmp Plugins
	use({ "hrsh7th/nvim-cmp", event = "InsertEnter", config = get_setup("cmp") }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" }) -- buffer completions
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
	use({ "tzachar/cmp-tabnine", after = "nvim-cmp", run = "./install.sh", config = get_setup("tabnine") })
	use({ "L3MON4D3/LuaSnip", event = "InsertEnter" }) -- snippet engine
	use({ "rafamadriz/friendly-snippets", event = "InsertEnter" }) -- a bunch of snippets to use

	-- LSP
	use({ "neovim/nvim-lspconfig", config = get_setup("lsp") }) -- enable LSP
	use({ "williamboman/nvim-lsp-installer" }) -- simple to use language server installer
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
	use({ "RRethy/vim-illuminate", config = get_setup("illuminate") })
	use({ "mfussenegger/nvim-jdtls", event = "BufWinEnter" })

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		opt = true,
		cmd = { "Telescope" },
		config = get_setup("telescope"),
	}) -- Fuzzy finder over lists. Items are shown in a popup with a prompt to search over.
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- It is a c port of the fzf algorithm
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({ "nvim-telescope/telescope-project.nvim" })

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", config = get_setup("treesitter") }) -- A parsing library that allows syntax highlighting, code nav, etc.
	use({ "lewis6991/spellsitter.nvim", config = get_setup("spellsitter") })

	-- Debugger
	use({
		"mfussenegger/nvim-dap",
		opt = true,
		cmd = { "DapToggleBreakpoint" },
		config = get_setup("dap"),
	}) -- A Debug Adapter Protocol client implementation for Neovim
	use({ "rcarriga/nvim-dap-ui", after = "nvim-dap" })
	use({ "ravenxrz/DAPInstall.nvim", after = "nvim-dap" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
