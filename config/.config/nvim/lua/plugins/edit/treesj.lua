return {
	"Wansmer/treesj",
	cmd = { "TSJToggle" },
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	config = true,
	keys = {
		{ "<leader>tt", "TSJToggle<CR>", desc = "Toggle structs" },
	},
}
