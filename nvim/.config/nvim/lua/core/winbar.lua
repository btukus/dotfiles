local M = {}

M.winbar_filetype_exclude = {
	"help",
	"startify",
	"dashboard",
	"DiffviewFiles",
	"packer",
	"neogitstatus",
	"NvimTree",
	"Trouble",
	"alpha",
	"lir",
	"Outline",
	"spectre_panel",
	"toggleterm",
	"DressingSelect",
	"Jaq",
	"",
}

local get_filename = function()
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local f = require("core.functions")

	if not f.isempty(filename) then
		local file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(
			filename,
			extension,
			{ default = true }
		)

		local hl_group = "FileIconColor" .. extension

		vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
		if f.isempty(file_icon) then
			file_icon = ""
			file_icon_color = ""
		end
		vim.api.nvim_set_hl(0, "Winbar", { fg = "#6b737f" })

		return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
	end
end

local excludes = function()
	if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
		vim.opt_local.winbar = nil
		return true
	end
	return false
end

M.get_winbar = function()
	if excludes() then
		return
	end
	local f = require("core.functions")
	local value = get_filename()

	if not f.isempty(value) and f.get_buf_option("mod") then
		local mod = "%#LspCodeLens#" .. require("core.icons").ui.CircleSpace .. "%*"
		if gps_added then
			value = value .. " " .. mod
		else
			value = value .. mod
		end
	end

	local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
	if not status_ok then
		return
	end
end

return M
