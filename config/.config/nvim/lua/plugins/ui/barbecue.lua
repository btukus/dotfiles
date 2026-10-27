return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  -- Load with the first file so the winbar is there in the first frame; VeryLazy would
  -- add it after the first draw and push the text down a line.
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      "SmiteshP/nvim-navic",
      -- navic attaches itself so it can choose between servers sharing a buffer (helm_ls
      -- and yamlls on Helm values files); barbecue's attach would warn on the second one.
      opts = { lsp = { auto_attach = true, preference = { "yamlls" } } },
    },
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    attach_navic = false,
  },
}
