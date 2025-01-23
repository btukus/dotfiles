local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader key
map("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- yank to system clipboard
map({"n", "v"}, "<leader>y", '"+y', opts)

-- paste from system clipboard
map({"n", "v"}, "<leader>p", '"+p', opts)

-- better indent handling
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- move text up and down
map("v", "J", ":m .+1<CR>==", opts)
map("v", "K", ":m .-2<CR>==", opts)
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

-- paste preserves primal yanked piece
map("v", "p", '"_dP', opts)

-- removes highlighting after escaping vim search
map("n", "<Esc>", "<Esc>:noh<CR>", opts)
