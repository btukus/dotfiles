return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen" },
	config = true,
	keys = {
		{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
	},
}
