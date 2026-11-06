-- Mason sets up PATH at startup; servers are enabled in lspconfig.lua.
-- The install check stays delayed so it does not block startup.
return {
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
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- Its automatic install hook must be registered before VimEnter.
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			-- mason package names
			ensure_installed = {
				-- language servers
				"lua-language-server",
				"eslint-lsp",
				"json-lsp",
				"yaml-language-server",
				"helm-ls",
				"marksman",
				"bash-language-server",
				"html-lsp",
				"css-lsp",
				"tailwindcss-language-server",
				"prisma-language-server",
				"pyright",
				"terraform-ls",
				"tofu-ls",
				-- formatters
				"prettier",
				"stylua",
				"eslint_d",
				"yamlfix",
				"shfmt",
				-- linters
				"pylint",
				"markdownlint",
				"shellcheck",
				"yamllint",
				"jsonlint",
				"luacheck",
				"tflint",
			},
			-- The check reads mason's whole registry, so run it at most once a day.
			debounce_hours = 24,
			start_delay = 3000,
		},
	},
}
