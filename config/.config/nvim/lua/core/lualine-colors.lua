local colors = {
	darkgray = "#1c1e26",
	gray = "#727169",
	white = "#white",
	innerbg = nil,
	outerbg = "#16161D",
	normal = "#E95678",
	insert = "#25B2BC",
	visual = "#F09383",
	replace = "#F43E5C",
	command = "#e6c384",
}

return {
	normal = {
		a = { bg = colors.normal, fg = colors.outerbg, gui = "bold" },
		b = { bg = colors.outerbg, fg = colors.normal },
		c = { bg = colors.innerbg, fg = colors.white },
	},
	insert = {
		a = { bg = colors.insert, fg = colors.outerbg, gui = "bold" },
		b = { bg = colors.outerbg, fg = colors.insert },
		c = { bg = colors.innerbg, fg = colors.white },
	},
	visual = {
		a = { bg = colors.visual, fg = colors.outerbg, gui = "bold" },
		b = { bg = colors.outerbg, fg = colors.visual },
		c = { bg = colors.innerbg, fg = colors.white },
	},
	replace = {
		a = { bg = colors.replace, fg = colors.outerbg, gui = "bold" },
		b = { bg = colors.outerbg, fg = colors.replace },
		c = { bg = colors.innerbg, fg = colors.white },
	},
	command = {
		a = { bg = colors.command, fg = colors.outerbg, gui = "bold" },
		b = { bg = colors.outerbg, fg = colors.command },
		c = { bg = colors.innerbg, fg = colors.white },
	},
	inactive = {
		a = { bg = colors.outerbg, fg = colors.gray, gui = "bold" },
		b = { bg = colors.outerbg, fg = colors.gray },
		c = { bg = colors.innerbg, fg = colors.gray },
	},
}
