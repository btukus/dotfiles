return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"rshkarin/mason-nvim-lint",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local mason_nvim_lint = require("mason-nvim-lint")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"jdtls",
				"kotlin_language_server",
				"pyright",
				"cssls",
				"html",
				"tsserver",
				"lua_ls",
				"bashls",
				"jsonls",
				"yamlls",
				"dockerls",
				"terraformls",
				"tflint",
				"ansiblels",
				"bashls",
				"bicep",
				"graphql",
				"vimls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
				"yamlfix",
			},
		})

		mason_nvim_lint.setup({
			ensure_installed = {
				"eslint_d",
				"markdownlint",
				"shellcheck",
				"yamllint",
				"jsonlint",
				"luacheck",
				"pylint",
				"tflint",
				"ansible-lint",
			},
		})
	end,
}
