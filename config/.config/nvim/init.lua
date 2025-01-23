require("core")

if vim.g.vscode then
  require("config.vscode")
  -- require("core.vscode_keymaps")
else
  require("config.lazy")
end
