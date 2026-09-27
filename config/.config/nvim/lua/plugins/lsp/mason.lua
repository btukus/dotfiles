return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"prismals",
				"pyright",
				"eslint",
			},

			automatic_enable = {
				"lua_ls",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"pylint",
				"eslint_d",
				"yamlfix",
				"shfmt",
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	{
		"rshkarin/mason-nvim-lint",
		opts = {
			ensure_installed = {
				"markdownlint",
				"shellcheck",
				"yamllint",
				"jsonlint",
				"luacheck",
				"tflint",
			},
		},
	},
}
