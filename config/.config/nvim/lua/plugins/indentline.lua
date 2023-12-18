local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
  return
end

indent_blankline.setup({
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

})
