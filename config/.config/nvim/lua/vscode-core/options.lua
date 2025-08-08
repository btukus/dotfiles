local is_vscode = vim.g.vscode
if not is_vscode then
  return
end

-- Core options are already applied via `core/options.lua`.
-- Only apply VSCode-specific overrides here.

-- Hide Neovim statusline inside VSCode
vim.opt.laststatus = 0

-- Keep comment style preference
vim.g.italic_comments = false
