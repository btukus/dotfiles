return {
	"zbirenbaum/copilot.lua",
	-- cmd = "Copilot",
	event = "CursorMoved",
	-- config = true,
	enabled = false,
	config = function()
		require("copilot").setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<M-CR>",
				},
			},
		})
	end,
}
