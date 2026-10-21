-- nvim-treesitter's `main` branch: the archived `master` branch breaks on Neovim 0.12
-- (e.g. markdown code-block injections). `main` only installs parsers and queries;
-- highlighting and indent are enabled per filetype below. Building parsers needs the
-- `tree-sitter` CLI (brew "tree-sitter-cli").
local parsers = {
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
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- `main` does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
				callback = function(args)
					if not pcall(vim.treesitter.start, args.buf) then
						return
					end
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
