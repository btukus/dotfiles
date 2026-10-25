return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  -- Load with the first file so the winbar is there in the first frame; VeryLazy would
  -- add it after the first draw and push the text down a line.
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
  },
}
