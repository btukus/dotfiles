local lspconfig = require("lspconfig")

lspconfig.bashls.setup({
	filetypes = { "sh", "zsh" }, -- Associate zsh with bashls
})
