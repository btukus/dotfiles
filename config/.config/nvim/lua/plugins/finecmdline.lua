local status_ok, fineCmdline = pcall(require, "fine-cmdline")
if not status_ok then return end

fineCmdline.setup({
  cmdline = {
    enable_keymaps = true,
    smart_history = true,
    prompt = ': '
  },
  popup = {
    position = {
      row = '10%',
      col = '50%',
    },
    size = {
      width = '40%',
    },
    border = {
      style = 'rounded',
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  },
  hooks = {
    before_mount = function(input)
      -- code
    end,
    after_mount = function(input)
      -- code
    end,
    set_keymaps = function(imap, feedkeys)
      -- code
    end
  }
})
