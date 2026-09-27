return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	-- Ctrl-hjkl across nvim splits and Zellij panes (outside Zellij, core/keymaps.lua handles splits)
	{
		"swaits/zellij-nav.nvim",
		cond = vim.env.ZELLIJ ~= nil,
		event = "VeryLazy",
		keys = {
			{ "<c-h>", "<cmd>ZellijNavigateLeft<cr>", silent = true, desc = "navigate left" },
			{ "<c-j>", "<cmd>ZellijNavigateDown<cr>", silent = true, desc = "navigate down" },
			{ "<c-k>", "<cmd>ZellijNavigateUp<cr>", silent = true, desc = "navigate up" },
			{ "<c-l>", "<cmd>ZellijNavigateRight<cr>", silent = true, desc = "navigate right" },
		},
		opts = {},
	},
	"chrisgrieser/nvim-spider",
}
