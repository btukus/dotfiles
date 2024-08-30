-- Shorten function name
local map = vim.keymap.set
-- Silent map option
local opts = { silent = true }

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
map("n", "<leader>sh", "<C-w>q", opts)
map("n", "<leader>sl", "<C-w>o", opts)
map("n", "<leader>e", "<C-w>=", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
map("n", "<leader>c", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
map("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Toggle relative numbers
map("n", "<leader>rn", "<cmd>set relativenumber!<CR>", opts)

-- Insert --
map("n", "<leader>yy", ":%y+<cr>", opts)

-- Make visual mode consistent with other settings
map("v", "v", "<esc>V", opts)
map("n", "V", "v$h", opts)
map("n", "Y", "v$hy", opts)
map("n", "<leader>vg", "ggVG", opts)

-- Use backspace key for matching parens
map("n", "<BS>", "%", opts)
map("x", "<BS>", "%", opts)

-- Don't open command history
map("n", "q:", "<nop>", opts)

-- Don't copy when pasted
-- map("v", "p", '"_dP`[v`]=⁠ [v ⁠]', opts)
-- map("n", "p", "p`[v`]=⁠ [v ⁠]", opts)
-- map("n", "P", "P`[v`]=⁠ [v ⁠]", opts)
-- map("x", "p", function() return 'pgv"' .. vim.v.register .. "y" end, { remap = false, expr = true })

-- Don't yank when x
map("n", "x", '"_x', opts)

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

------------------------------- Plugins ------------------------------------

-- Telescope
map("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", opts)
map("n", "<leader>fd", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fp", ":Telescope projects<CR>", opts)
map("n", "<leader>fr", ":Telescope file_browser hidden=true<CR> ", opts)
map("n", "<leader>ft", ":Telescope file_browser hidden=true path=%:p:h select_buffer=true<CR> ", opts)

-- Git Conflict
map("n", "<leader>gl", ":GitConflictListQf<CR>", opts)

-- Git Diffview
-- map("n", "<leader>gv", ":DiffviewOpen<CR>", opts)
-- map("n", "<leader>gc", ":DiffviewClose<CR>", opts)

-- Git blame
map("n", "<leader>gb", ":BlameToggle<CR>", opts)

-- Harpoon
map("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
map("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
map("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", opts)
map("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", opts)

-- TroubleToggle
map("n", "<leader>dd", ":TroubleToggle<CR>", opts)

-- SymbolOutline
map("n", "<leader>so", ":SymbolsOutline<CR>", opts)

-- Git-conflict
map("n", "co", "<Plug>(git-conflict-ours)")
map("n", "<leader>ll", ":GitConflictListQf<CR>")
map("n", "ct", "<Plug>(git-conflict-theirs)")
map("n", "cb", "<Plug>(git-conflict-both)")
map("n", "c0", "<Plug>(git-conflict-none)")
map("n", "]x", "<Plug>(git-conflict-prev-conflict)")
map("n", "[x", "<Plug>(git-conflict-next-conflict)")

-- ThePrimeagen
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("x", "L", ">gv", opts)
map("x", "H", "<gv", opts)
map("x", "<leader>p", '"_dP')
-- TreeSJ
map("n", "<leader>tt", ":TSJToggle<CR>", opts)

-- Flutter-tools
map("n", "<leader>fq", ":FlutterRun<CR>", opts)
map("n", "<leader>fQ", ":FlutterQuit<CR>", opts)

-- -- LSP
-- map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
-- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
-- map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
-- map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
-- map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
-- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
-- map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
-- map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
-- map('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
-- map('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
-- map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
-- map('n', 'gL', '<cmd>lua vim.diagnostic.setqflist()<cr>', opts)
-- map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
-- map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
-- map('n', '<leader>gj', ':vsplit | lua vim.lsp.buf.definition()<CR>')
-- map('n', '<leader>gk', ':belowright split | lua vim.lsp.buf.definition()<CR>')
