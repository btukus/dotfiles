return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
			},
			indent = { enable = true },

			autotag = {
				enable = true,
			},
			ensure_installed = {
				"java",
				"javascript",
				"typescript",
				"tsx",
				"go",
				"gomod",
				"gosum",
				"python",
				"lua",

				-- Web/Frontend
				"html",
				"css",
				"scss",
				"json",
				"jsonc",

				-- DevOps/Infrastructure
				"yaml",
				"terraform",
				"hcl",
				"dockerfile",
				"helm",

				-- Useful extras
				"bash",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
				"query",
				"regex",
				"sql",
				"gitignore",
				"diff",
			},
		})
	end,
}
