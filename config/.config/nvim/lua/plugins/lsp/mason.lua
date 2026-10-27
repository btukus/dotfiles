-- Mason only installs tools; servers are enabled in lspconfig.lua. mason.nvim itself loads
-- at startup as its README recommends (setup is light and puts its bin dir on PATH for
-- servers, conform and nvim-lint); only the registry-reading install check is deferred.
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
		event = "VeryLazy",
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
