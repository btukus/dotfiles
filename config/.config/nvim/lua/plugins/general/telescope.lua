return {
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	keys = {
		{ "<leader>ff", ":Telescope find_files hidden=true<CR>", silent = true },
		{ "<leader>fd", ":Telescope live_grep<CR>", silent = true },
		{ "<leader>fp", ":Telescope projects<CR>", silent = true },
		{ "<leader>fr", ":Telescope file_browser hidden=true<CR> ", silent = true },
		{ "<leader>ft", ":Telescope file_browser hidden=true path=%:p:h select_buffer=true<CR> ", silent = true },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.load_extension("file_browser")
		telescope.load_extension("projects")

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					-- "--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
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
				path_display = { "smart" },
				file_ignore_patterns = { "node%_modules/.*", "__pycache__/*", "venv/*" },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				file_browser = {
					theme = "ivy",
					hijack_netrw = true,
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						-- even more opts
					}),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
	end,
}
