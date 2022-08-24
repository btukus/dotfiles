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
-- Press jk fast to enter
keymap("i", "kl", "<ESC>", opts)
keymap("n", "<leader>yy", ":%y+<cr>")

-- Plugins --

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

-- Git Conflict
keymap("n", "<leader>gl", "GitConflictListQf<CR>", opts)

-- Git Diffview
keymap("n", "<leader>gv", ":DiffviewOpen<CR>", opts)
keymap("n", "<leader>gc", ":DiffviewClose<CR>", opts)

-- Git-worktree
keymap("n", "<leader>gt", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", opts)

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

-- DAP
keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
