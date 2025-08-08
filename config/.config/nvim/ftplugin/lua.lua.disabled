if not vim.g.vscode then
	local lspconfig = require("lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")

	lspconfig.lua_ls.setup({
		capabilities = cmp_nvim_lsp.default_capabilities(),
		settings = {
			Lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	})
end
