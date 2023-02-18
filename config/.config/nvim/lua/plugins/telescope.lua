local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.load_extension("fzf")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
telescope.load_extension("git_worktree")
telescope.load_extension('lazygit')

telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "  ",
		selection_caret = "  ",
		initial_mode = "insert",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},

		file_ignore_patterns = { "node_modules", ".git" },
		path_display = { "smart" },
	},
	pickers = {},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		file_browser = {
			initial_mode = "normal",
			theme = "ivy",
			hijack_netrw = true,
		},
	},
})
