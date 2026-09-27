return {
	"nvim-mini/mini.nvim",
	version = false,
	lazy = false,
	config = function()
		require("mini.pairs").setup()
		require("mini.surround").setup()
		require("mini.splitjoin").setup()
		require("mini.move").setup({
			mappings = {
				left = "H",
				right = "L",
				down = "J",
				up = "K",
				line_left = "",
				line_right = "",
				line_down = "",
				line_up = "",
			},
		})
	end,
}
