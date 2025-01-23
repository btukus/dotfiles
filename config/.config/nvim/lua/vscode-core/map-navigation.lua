local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local vscode = require('vscode')

vim.keymap.set({ "n", "x" }, "<C-l>", function()
    vscode.action("workbench.action.focusRightGroup")
end)

vim.keymap.set({ "n", "x" }, "<C-h>", function()
    vscode.action("workbench.action.focusLeftGroup")
end)

vim.keymap.set({ "n", "x" }, "<C-k>", function()
    vscode.action("workbench.action.focusAboveGroup")
end)

vim.keymap.set({ "n", "x" }, "<C-j>", function()
    vscode.action("workbench.action.focusBelowGroup")
end)

vim.keymap.set({ "n", "x" }, "<leader>sj", function()
    vscode.action("workbench.action.splitEditorDown")
end)

vim.keymap.set({ "n", "x" }, "<leader>sk", function()
    vscode.action("workbench.action.splitEditorRight")
end)
