local status_ok, jabs = pcall(require, "jabs")
if not status_ok then
  return
end

jabs.setup {
  -- Options for the main window
  position = 'center', -- center, corner. Default corner
  width = 60,
  height = 15,
  border = 'rounded',


  preview_position = 'right',
  preview = {
    width = 70,
    height = 20,
    border = "rounded", -- none, single, double, rounded, solid, shadow, (or an array or chars)
  },

  use_devicons = true,
}
