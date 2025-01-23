require("core")

if vim.g.vscode then
  require("vscode-core")
  require("config.vscode")
else
  require("nvim-core")
  require("config.lazy")
end
