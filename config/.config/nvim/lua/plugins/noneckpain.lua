local status_ok, noneck = pcall(require, "no-neck-pain")
if not status_ok then return end

noneck.setup({
  buffers = {
    -- right = {
    --   enabled = false,
    -- },
    -- left = {
    --   enabled = false,
    -- }
  }
})
