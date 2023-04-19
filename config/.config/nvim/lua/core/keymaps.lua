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
--[[ map("v", "p", '"_dP`]', opts) ]]

-- Don't yank when x
map("n", "x", '"_x', opts)

-- Auto indentation on empty lines
function autoIndent(key)
	return function()
		return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_cc' or key
	end
end

map("n", "i", autoIndent("i"), { expr = true, noremap = true })
map("n", "I", autoIndent("I"), { expr = true, noremap = true })
map("n", "a", autoIndent("a"), { expr = true, noremap = true })
map("n", "A", autoIndent("A"), { expr = true, noremap = true })

------------------------------- Plugins ------------------------------------

-- Packer
map("n", "<leader>ps", ":PackerSync<CR>", opts)
map("n", "<leader>pp", ":PackerProfile<CR>", opts)
map("n", "<leader>pS", ":PackerStatus<CR>", opts)

-- Telescope
map("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", opts)
map("n", "<leader>fd", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fp", ":Telescope projects<CR>", opts)
map("n", "<leader>fr", ":Telescope file_browser hidden=true<CR> ", opts)
map("n", "<leader>ft", ":Telescope file_browser hidden=true path=%:p:h select_buffer=true<CR> ", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fa", ":Telescope terraform_doc full_name=hashicorp/azurerm<CR>", opts)


-- Nvim-Tree
map("n", "<leader>nn", ":NvimTreeToggle<CR>", opts)

-- Git Conflict
map("n", "<leader>gl", "GitConflictListQf<CR>", opts)

-- Git Diffview
map("n", "<leader>gv", ":DiffviewOpen<CR>", opts)
map("n", "<leader>gc", ":DiffviewClose<CR>", opts)

-- Git-worktree
map("n", "<leader>gt", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", opts)

-- Lazygit
map("n", "<leader>gg", ":LazyGit<CR>", opts)

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
map("x", "<leader>p", "\"_dP")

-- TreeSJ
map("n", "<leader>tt", ":TSJToggle<CR>", opts)
