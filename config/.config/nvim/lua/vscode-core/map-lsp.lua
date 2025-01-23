local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local vscode = require('vscode')

vim.keymap.set({ "n", "x" }, "<leader>lf", function()
    vscode.action("editor.action.formatDocument")
end)

vim.keymap.set({ "n", "x" }, "<leader>tt", function()
    vscode.action("workbench.action.terminal.toggleTerminal")
end)

vim.keymap.set({ "n", "x" }, "gl", function()
    vscode.action("editor.action.showHover")
end)

vim.keymap.set({ "n", "x" }, "<leader>oo", function()
    vscode.action("editor.action.organizeImports")
end)

vim.keymap.set({ "n", "x" }, "gd", function()
    vscode.action("editor.action.revealDefinition")
end)
