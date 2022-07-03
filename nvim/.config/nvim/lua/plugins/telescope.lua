local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.load_extension("fzf")
telescope.load_extension("project")
telescope.load_extension("file_browser")
-- telescope.load_extension("ui-select")
telescope.load_extension("git_worktree")
telescope.load_extension("harpoon")

local actions = require("telescope.actions")

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
		prompt_prefix = " ",
		selection_caret = " ",
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
		project = {
			initial_mode = "normal",
			base_dirs = {
				"~/dev/src",
				{ "~/dev/src2" },
				{ "~/dev/src3", max_depth = 4 },
				{ path = "~/dev/src4" },
				{ path = "~/dev/src5", max_depth = 2 },
			},
			hidden_files = true,
			theme = "dropdown",
		},
		file_browser = {
			initial_mode = "normal",
			theme = "ivy",
			hijack_netrw = true,
		},
		-- ["ui-select"] = {
		--   require("telescope.themes").get_dropdown {}
		-- }
	},
})
