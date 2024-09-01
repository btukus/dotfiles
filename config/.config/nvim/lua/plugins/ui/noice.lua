return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = { inc_rename = true },
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
	},
}
