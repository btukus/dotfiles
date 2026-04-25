return {
  "senseylabs/claude-legion",
  enabled = true,
  lazy = false,
  config = function()
    require("claude-legion").setup()
  end,
}
