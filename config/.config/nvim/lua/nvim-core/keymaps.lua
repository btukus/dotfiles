-- Shorten function name
local map = vim.keymap.set
-- Silent map option
local opts = { silent = true }

-- Normal --
-- Close Neovim
map("n", "<leader>qq", ":q!<CR>", opts)
map("n", "<leader>wq", ":wq<CR>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Split window
map("n", "<leader>sj", "<C-w>s", opts)
map("n", "<leader>sk", "<C-w>v", opts)
map("n", "<leader>e", "<C-w>=", opts)

-- Move Splits 
map("n", "<leader>sh", "<C-w>H", opts)
map("n", "<leader>sl", "<C-w>L", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
map("n", "<leader>c", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
map("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Don't open command history
map("n", "q:", "<nop>", opts)

-- Auto indentation on empty lines
function autoIndent(key)
	return function()
		return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_cc' or key
	end
end

local keys = { "i", "I", "a", "A" }
for _, key in ipairs(keys) do
	map("n", key, autoIndent(key), { expr = true, noremap = true })
end
