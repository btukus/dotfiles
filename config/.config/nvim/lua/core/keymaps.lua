-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Close Neovim
keymap("n", "<leader>qq", ":q!<CR>", opts)
keymap("n", "<leader>wq", ":wq<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Split window
keymap("n", "<leader>sj", "<C-w>s", opts)
keymap("n", "<leader>sk", "<C-w>v", opts)
keymap("n", "<leader>sh", "<C-w>q", opts)
keymap("n", "<leader>sl", "<C-w>o", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>c", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Insert --
keymap("n", "<leader>yy", ":%y+<cr>")

-- Make visual mode consistent with other settings
keymap("v", "v", "<esc>V", opts)
keymap("n", "V", "v$h", opts)
keymap("n", "Y", "v$hy", opts)

-- Use backspace key for matching parens
keymap("n", "<BS>", "%", opts)
keymap("x", "<BS>", "%", opts)

-- Don't open command history
keymap("n", "q:", "<nop>", opts)

-- Don't copy when pasted
keymap("v", "p", '"_dP`]', opts)

-- Don't yank when x
keymap("n", "x", '"_x', opts)

-- but blank line below
keymap("n", "<cr>", "o<esc>k", opts)

-- Auto indentation on empty lines
function autoIndent(key)
	return function()
		return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_cc' or key
	end
end

vim.keymap.set("n", "i", autoIndent("i"), { expr = true, noremap = true })
vim.keymap.set("n", "I", autoIndent("I"), { expr = true, noremap = true })
vim.keymap.set("n", "a", autoIndent("a"), { expr = true, noremap = true })
vim.keymap.set("n", "A", autoIndent("A"), { expr = true, noremap = true })

------------------------------- Plugins ------------------------------------

-- Packer
keymap("n", "<leader>ps", ":PackerSync<CR>", opts)
keymap("n", "<leader>pp", ":PackerProfile<CR>", opts)
keymap("n", "<leader>pS", ":PackerStatus<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", opts)
keymap("n", "<leader>fd", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>ft", ":Telescope file_browser hidden=true<CR> ", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Nvim-Tree
keymap("n", "<leader>nn", ":NvimTreeToggle<CR>", opts)

-- Git Conflict
keymap("n", "<leader>gl", "GitConflictListQf<CR>", opts)

-- Git Diffview
keymap("n", "<leader>gv", ":DiffviewOpen<CR>", opts)
keymap("n", "<leader>gc", ":DiffviewClose<CR>", opts)

-- Git-worktree
keymap("n", "<leader>gt", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", opts)

-- Lazygit
keymap("n", "<leader>gg", ":LazyGit<CR>", opts)

-- Harpoon
keymap("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
keymap("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
keymap("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", opts)
keymap("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", opts)

-- ToggleTerm
keymap("n", "<leader>t", ":ToggleTerm<CR>", opts)

-- TroubleToggle
keymap("n", "<leader>dd", ":TroubleToggle<CR>", opts)

-- SymbolOutline
keymap("n", "<leader>so", ":SymbolsOutline<CR>", opts)

-- Git-conflict
keymap("n", "co", "<Plug>(git-conflict-ours)")
keymap("n", "ct", "<Plug>(git-conflict-theirs)")
keymap("n", "cb", "<Plug>(git-conflict-both)")
keymap("n", "c0", "<Plug>(git-conflict-none)")
keymap("n", "]x", "<Plug>(git-conflict-prev-conflict)")
keymap("n", "[x", "<Plug>(git-conflict-next-conflict)")

--Rexgexplainer
keymap("n", "<leader>rg", ":RegexplainerToggle<CR>")

-- ThePrimeagen
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("x", "L", ">gv", opts)
keymap("x", "H", "<gv", opts)
keymap("x", "<leader>p", "\"_dP")

keymap("n", "<leader>tt", ":TSJToggle<CR>", opts)
