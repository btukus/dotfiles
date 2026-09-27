return {
	"FabijanZulj/blame.nvim",
	cmd = { "BlameToggle" },
	config = function()
		require("blame").setup()
	end,
	keys = {
		{ "<leader>gb", ":BlameToggle<cr>", desc = "Open Blame toggle" },
	},
}
