return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	-- Ctrl-hjkl across nvim splits and tmux panes (outside tmux, core/keymaps.lua handles splits).
	-- Not lazy: it sets tmux's @pane-is-vim on startup, which tmux.conf's Ctrl-hjkl bindings check.
	{
		"mrjones2014/smart-splits.nvim",
		cond = vim.env.TMUX ~= nil,
		lazy = false,
		keys = {
			{ "<c-h>", function() require("smart-splits").move_cursor_left() end, desc = "navigate left" },
			{ "<c-j>", function() require("smart-splits").move_cursor_down() end, desc = "navigate down" },
			{ "<c-k>", function() require("smart-splits").move_cursor_up() end, desc = "navigate up" },
			{ "<c-l>", function() require("smart-splits").move_cursor_right() end, desc = "navigate right" },
		},
		opts = { at_edge = "stop" },
	},
	"chrisgrieser/nvim-spider",
}
