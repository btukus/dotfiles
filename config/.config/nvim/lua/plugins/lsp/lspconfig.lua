return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
		})

		local map = vim.keymap.set
		local opts = { silent = true }

		map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
		map("n", "gL", "<cmd>lua vim.diagnostic.setqflist()<cr>", opts)
		map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
		map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)

		map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		map("n", "<leader>gj", ":vsplit | lua vim.lsp.buf.definition()<CR>")
		map("n", "<leader>gk", ":belowright split | lua vim.lsp.buf.definition()<CR>")

		map("n", "<leader>li", ":LspInfo<CR>", opts)
		map("n", "<leader>lm", ":Mason<CR>", opts)
	end,
}
