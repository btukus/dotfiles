return {
  "akinsho/git-conflict.nvim",
  tags = "*",
  cmd = { "GitConflictChooseOurs", "GitConflictChooseBase", "GitConflictPrev", "GitConflictListQf" },
  opts = {
    default_mappings = true,          -- disable buffer local mapping created by this plugin
    disable_diagnostics = false,      -- This will disable the diagnostics in a buffer whilst it is conflicted
    highlights = {                    -- They must have background color, otherwise the default color will be used
      incoming = 'DiffText',
      current = 'DiffAdd',
    }
  }
}
