-- Shorten function name
--[[ local vim.keymap.set = vim.keymap.set ]]
-- Silent vim.keymap.set option
local opts = { silent = true }

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Close Neovim
vim.keymap.set("n", "<leader>qq", ":q!<CR>", opts)
vim.keymap.set("n", "<leader>wq", ":wq<CR>", opts)

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Split window
vim.keymap.set("n", "<leader>sj", "<C-w>s", opts)
vim.keymap.set("n", "<leader>sk", "<C-w>v", opts)
vim.keymap.set("n", "<leader>sh", "<C-w>q", opts)
vim.keymap.set("n", "<leader>sl", "<C-w>o", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
vim.keymap.set("n", "<leader>c", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
vim.keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Insert --
vim.keymap.set("n", "<leader>yy", ":%y+<cr>", opts)

-- Make visual mode consistent with other settings
vim.keymap.set("v", "v", "<esc>V", opts)
vim.keymap.set("n", "V", "v$h", opts)
vim.keymap.set("n", "Y", "v$hy", opts)
vim.keymap.set("n", "<leader>vg", "ggVG", opts)

-- Use backspace key for matching parens
vim.keymap.set("n", "<BS>", "%", opts)
vim.keymap.set("x", "<BS>", "%", opts)

-- Don't open command history
vim.keymap.set("n", "q:", "<nop>", opts)

-- Don't copy when pasted
--[[ vim.keymap.set("v", "p", '"_dP`]', opts) ]]

-- Don't yank when x
vim.keymap.set("n", "x", '"_x', opts)

-- Auto indentation on empty lines
function autoIndent(key)
	return function()
		return string.match(vim.api.nvim_get_current_line(), "%g") == nil and '"_cc' or key
	end
end

vim.vim.keymap.set.set("n", "i", autoIndent("i"), { expr = true, noremap = true })
vim.vim.keymap.set.set("n", "I", autoIndent("I"), { expr = true, noremap = true })
vim.vim.keymap.set.set("n", "a", autoIndent("a"), { expr = true, noremap = true })
vim.vim.keymap.set.set("n", "A", autoIndent("A"), { expr = true, noremap = true })

------------------------------- Plugins ------------------------------------

-- Packer
vim.keymap.set("n", "<leader>ps", ":PackerSync<CR>", opts)
vim.keymap.set("n", "<leader>pp", ":PackerProfile<CR>", opts)
vim.keymap.set("n", "<leader>pS", ":PackerStatus<CR>", opts)

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", opts)
vim.keymap.set("n", "<leader>fd", ":Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", opts)
vim.keymap.set("n", "<leader>fr", ":Telescope file_browser hidden=true<CR> ", opts)
vim.keymap.set("n", "<leader>ft", ":Telescope file_browser hidden=true path=%:p:h select_buffer=true<CR> ", opts)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>fa", ":Telescope terraform_doc full_name=hashicorp/azurerm<CR>", opts)


-- Nvim-Tree
vim.keymap.set("n", "<leader>nn", ":NvimTreeToggle<CR>", opts)

-- Git Conflict
vim.keymap.set("n", "<leader>gl", "GitConflictListQf<CR>", opts)

-- Git Diffview
vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>", opts)
vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", opts)

-- Git-worktree
vim.keymap.set("n", "<leader>gt", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", opts)

-- Lazygit
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", opts)

-- Harpoon
vim.keymap.set("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
vim.keymap.set("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
vim.keymap.set("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", opts)
vim.keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", opts)

-- TroubleToggle
vim.keymap.set("n", "<leader>dd", ":TroubleToggle<CR>", opts)

-- SymbolOutline
vim.keymap.set("n", "<leader>so", ":SymbolsOutline<CR>", opts)

-- Git-conflict
vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "<leader>ll", ":GitConflictListQf<CR>")
vim.keymap.set("n", "ct", "<Plug>(git-conflict-theirs)")
vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
vim.keymap.set("n", "c0", "<Plug>(git-conflict-none)")
vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)")
vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)")

-- ThePrimeagen
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "L", ">gv", opts)
vim.keymap.set("x", "H", "<gv", opts)
vim.keymap.set("x", "<leader>p", "\"_dP")

-- TreeSJ
vim.keymap.set("n", "<leader>tt", ":TSJToggle<CR>", opts)
