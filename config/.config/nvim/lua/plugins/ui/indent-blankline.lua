return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    scope = {
      show_start = false,
      show_end = false,
    },
    indent = {
      char = "▏",
    },
    whitespace = {
      remove_blankline_trail = false,
    },
  },
}
