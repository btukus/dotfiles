if not vim.g.vscode then
	local lspconfig = require("lspconfig")

	lspconfig.bashls.setup({
		filetypes = { "sh", "zsh" }, -- Associate zsh with bashls
	})
end
