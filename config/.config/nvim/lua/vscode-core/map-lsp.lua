local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local vscode = require('vscode')

vim.keymap.set({ "n", "x" }, "<leader>lf", function()
    vscode.action("editor.action.formatDocument")
end)

vim.keymap.set({ "n", "x" }, "<leader>la", function()
    vscode.action("editor.action.fixAll")
end)

vim.keymap.set({ "n", "x" }, "<leader>li", function()
    vscode.action("editor.action.organizeImports")
end)

vim.keymap.set({ "n", "x" }, "<leader>tt", function()
    vscode.action("workbench.action.terminal.toggleTerminal")
end)

vim.keymap.set({ "n", "x" }, "gl", function()
    vscode.action("editor.action.showHover")
end)

vim.keymap.set({ "n", "x" }, "gd", function()
    vscode.action("editor.action.revealDefinition")
end)

vim.keymap.set({ "n", "x" }, "gi", function()
    vscode.action("editor.action.goToImplementation")
end)

vim.keymap.set({ "n", "x" }, "gr", function()
    vscode.action("editor.action.goToReferences")
end)
