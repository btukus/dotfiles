return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  -- Whichever comes first; on LspAttach lazy.nvim replays the event so navic still attaches.
  event = { "VeryLazy", "LspAttach" },
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
  },
}
