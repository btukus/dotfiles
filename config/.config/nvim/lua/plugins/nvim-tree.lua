local status_ok, NvimTree = pcall(require, "nvim-tree")
if not status_ok then return end

NvimTree.setup()
