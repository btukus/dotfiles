if vim.g.vscode then
  require("vscode-core")
  require("config.vscode")
else
  require("core")
  require("config.lazy")
end
