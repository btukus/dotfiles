return {
	"VonHeikemen/searchbox.nvim",
	config = function()
		require("searchbox").setup()
		vim.keymap.set("n", "<leader>rr", ":SearchBoxReplace<CR>")
		vim.keymap.set("n", "<leader>rw", ":SearchBoxReplace -- <C-r>=expand('<cword>')<CR><CR>")
	end,
}
