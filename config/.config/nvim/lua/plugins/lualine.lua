local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local status, colorscheme = pcall(require, "core.lualine-colors")
if not status then
	return
end

local status_ok, spotify = pcall(require, "nvim-spotify")
if not status_ok then
	return
end

local spotify_status = spotify.status
spotify_status:start()

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local icons = require("core.icons")

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = icons.lualine.Error, warn = icons.lualine.Warning },
	colored = true,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = icons.git.Add, modified = icons.git.Mod, removed = icons.git.Remove }, -- changes diff symbols
	cond = hide_in_width,
}

local filename = {
	"filename",
	path = 2,
	shorting_target = 40,
	symbols = {
		modified = " ●", -- Text to show when the buffer is modified
		alternate_file = "#", -- Text to show to identify the alternate file
		directory = "", -- Text to show when the buffer is a directory
		unnamed = "",
	},
}

local filetype = {
	"filetype",
	icons_enabled = false,
}

local location = {
	"location",
}

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		theme = colorscheme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard" },
		always_divide_middle = true,
	},
	-- sections = {
	-- 	lualine_a = { "mode" },
	-- 	lualine_b = { "branch" },
	-- 	lualine_c = { diagnostics },
	-- 	lualine_x = { spotify_status.listen },
	-- 	lualine_y = { location },
	-- 	lualine_z = { "progress" },
	-- },
	tabline = {
		lualine_a = {
			"mode",
		},
		lualine_b = { "branch" },
		lualine_c = { filename },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})
