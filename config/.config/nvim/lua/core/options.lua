local options = {

	-- Nvim configuration
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	hlsearch = false, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	conceallevel = 0, -- so that `` is visible in markdown files
	mouse = "a", -- allow the mouse to be used in neovim
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	termguicolors = true, -- set term gui colors (most terminals support this)
	numberwidth = 2, -- set number column width to 2 {default 4}
	number = true,
	relativenumber = true, -- set numbered lines
	laststatus = 0,
  ea = true,

	-- File configuration options
	backup = false, -- creates a backup file
	fileencoding = "utf-8", -- the encoding written to a file
	cmdheight = 1, -- more space in the neovim command line for displaying messages
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	swapfile = false, -- creates a swapfile
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	undofile = true, -- enable persistent undo
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time

	-- Key mapping configuration
	timeoutlen = 750, -- time to wait for a mapped sequence to complete (in milliseconds)
	updatetime = 300, -- faster completion (4000ms default)

	-- Space and Tab configuration
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	tabstop = 2, -- insert 2 spaces for a tab
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation

	-- Overflowing jext
	wrap = false, -- display lines as one long line
	scrolloff = 8, -- is one of my fav
	sidescrolloff = 8,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.fillchars.eob = " "
vim.opt.shortmess:append("c")
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")

vim.g.italic_comments = false
