-- Shorten function name
local map = vim.keymap.set
-- Silent map option
local opts = { silent = true }

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Toggle relative numbers
map("n", "<leader>rn", "<cmd>set relativenumber!<CR>", opts)

-- Copy everything in the buffer
map("n", "<leader>yy", ":%y+<cr>", opts)

-- Make visual mode consistent with other settings
map("v", "v", "<esc>V", opts)
map("n", "V", "v$h", opts)
map("n", "Y", "v$hy", opts)
map("n", "<leader>vg", "ggVG", opts)

-- Use backspace key for matching parens
map("n", "<BS>", "%", opts)
map("x", "<BS>", "%", opts)

-- Don't yank when x
map("n", "x", '"_x', opts)

-- ThePrimeagen
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("x", "L", ">gv", opts)
map("x", "H", "<gv", opts)
map("x", "<leader>p", '"_dP')

-- go to end of line
local modes = { "n", "v", "s", "o" }
for _, mode in ipairs(modes) do
	map(mode, "$", "g_", opts)
end

-- Paste over visual selection
local symbols = { "(", "[", "{", "'", '"', "`" }
for _, symbol in ipairs(symbols) do
	map("n", "<leader>p" .. symbol, "vi" .. symbol .. "p", opts)
	map("n", "<leader>P" .. symbol, "va" .. symbol .. "p", opts)
end
