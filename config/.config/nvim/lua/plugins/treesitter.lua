local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "all",
  ignore_install = {},
	highlight = {
		enable = true,
    disable = {
      "yaml",
    },
	},
	autopairs = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	indent = {
    enable = true,
    disable = {
      "python",
      "css",
      "yaml",
    },
  },
})
