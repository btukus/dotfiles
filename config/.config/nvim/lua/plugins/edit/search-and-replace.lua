return {
	"s1n7ax/nvim-search-and-replace",
	cmd = { "SReplace", "SReplaceAll", "SReplaceAndSave", "SReplaceAllAndSave" },
	config = true,
	keys = {
		{ "<leader>sr", ":SReplace<cr>", desc = "Search and replace" },
		{ "<leader>sa", ":SReplaceAll<cr>", desc = "Search and replace all including ignored files" },
		{ "<leader>ss", ":SReplaceAndSave<cr>", desc = "Search and replace and save" },
		{ "<leader>sa", ":SReplaceAllAndSave<cr>", desc = "Search and replace all including ignored files and save" },
	},
}
