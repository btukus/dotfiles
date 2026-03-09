return {
  name = "claude-legion",
  dir = "/Users/btukus/drive/mac/development/sensey/claude-legion/main",
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>an", "<cmd>ClaudeCodeNew<cr>", desc = "New Claude instance" },
    { "<leader>aa", "<cmd>ClaudeCodeSelect<cr>", desc = "List all terminals" },
    { "<leader>at", "<cmd>ClaudeTerminal<cr>", desc = "New plain terminal" },
    { "<leader>as", ":'<,'>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>ak", "<cmd>ClaudeCodeKill<cr>", desc = "Kill Claude instance" },
    { "<leader>wc", "<cmd>ClaudeWorktreeCreate<cr>", desc = "Create git worktree" },
    { "<leader>wl", "<cmd>ClaudeWorktreeList<cr>", desc = "List git worktrees" },
  },
  config = function()
    require("claude-legion").setup()
  end,
}
