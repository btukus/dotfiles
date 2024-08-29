return {
	{
		"projekt0n/github-nvim-theme",
		priority = 1000,
		config = function()
			require("github-theme").setup({
				-- Customize the theme settings if needed
			})
			vim.cmd("colorscheme github_dark_dimmed")
		end,
	},
}
