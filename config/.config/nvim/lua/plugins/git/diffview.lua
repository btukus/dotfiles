return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen" },
	config = true,
	keys = {
		{ "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
		{ "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
		{ "<leader>gt", "<cmd>DiffviewToggleFiles<CR>", desc = "Close diff view" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff1_plain",
				disable_diagnostics = true,
				winbar_info = true,
			},
		},
	},
}
