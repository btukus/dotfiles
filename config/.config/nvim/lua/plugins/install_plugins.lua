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
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost install_plugins.lua source <afile> | PackerSync
  augroup end
]])

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

local currentTheme = "github-nvim-theme"

function get_setup(name)
	return string.format('require("plugins/%s")', name)
end

return packer.startup(function(use)
	-- Neovim Config
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "lewis6991/impatient.nvim", config = get_setup("impatient") })
	use({ "aserowy/tmux.nvim", config = get_setup("tmux") })

	-- Regex
	use({ "MunifTanjim/nui.nvim", opt = true, cmd = { "RegexplainerToggle" } })
	use({
		"bennypowers/nvim-regexplainer",
		after = "nui.nvim",
		config = get_setup("regexplainer"),
	})

	-- Motion
	use({ "ggandor/leap.nvim", config = get_setup("leap") })

	-- Window and session management
	use({ "ThePrimeagen/harpoon" })
	use({
		"simrat39/symbols-outline.nvim",
		opt = true,
		cmd = { "SymbolsOutline" },
		config = get_setup("symbols_outline"),
	})
	use({ "anuvyklack/hydra.nvim", opt = true, keys = { "<C-w>" }, config = get_setup("hydra") })
	use({ "folke/trouble.nvim", opt = true, cmd = { "TroubleToggle" } })

	-- Text Editing
	use({
		"numToStr/Comment.nvim",
		opt = true,
		keys = { "gc", "gcc", "gbc" },
		config = get_setup("comment"),
	})
	use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "Comment.nvim" })
	use({ "windwp/nvim-autopairs", after = "nvim-cmp", config = get_setup("autopairs") })
	use({ "windwp/nvim-ts-autotag" })
	use({ "kylechui/nvim-surround", config = get_setup("nvim-surround") })
	-- use({ "kevinhwang91/nvim-ufo", config = get_setup("nvim_ufo"), requires = "kevinhwang91/promise-async" })

	-- Buffer Plugins
	use({ "moll/vim-bbye", opt = true, cmd = { "Bdelete" } })
	use({ "ethanholz/nvim-lastplace", config = get_setup("lastplace") })

	use({ "kyazdani42/nvim-web-devicons" })
	use({ "lukas-reineke/indent-blankline.nvim", event = "BufReadPre", config = get_setup("indentline") })
	use({ "goolord/alpha-nvim", config = get_setup("alpha") })

	-- Colorschemes
	-- use({ "lunarvim/darkplus.nvim" })
	use({ "projekt0n/github-nvim-theme" })
	-- use({ 'elvessousa/sobrio' })

	-- Git
	use({
		"akinsho/git-conflict.nvim",
		--[[ opt = true, ]]
		--[[ keys = { "co", "ct", "cb", "c0", "]x", "[x" }, ]]
    tag = "*",
		config = get_setup("git-conflict"),
	})
	use({ "ThePrimeagen/git-worktree.nvim", config = get_setup("git-worktree") })
	use({ "sindrets/diffview.nvim", opt = true, cmd = { "DiffviewOpen" } })

  use {
	  'VonHeikemen/lsp-zero.nvim',
    config = get_setup("lsp-zero"),
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }
  use({
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		-- event = "BufWinEnter",
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		opt = true,
		cmd = { "Telescope" },
		config = get_setup("telescope"),
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({ "ahmedkhalf/project.nvim", config = get_setup("project") })
  use({'nvim-telescope/telescope-media-files.nvim'})
	-- use({ "nvim-telescope/telescope-project.nvim" })

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", config = get_setup("treesitter") })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
