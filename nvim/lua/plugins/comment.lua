local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup {
  pre_hook = function(ctx)
    local U = require "Comment.utils"

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    }
  end,
}

-- Mappings
--
-- NORMAL mode
-- gcc - Toggles the current line using linewise comment
-- gbc - Toggles the current line using blockwise comment
-- [count]gcc - Toggles the number of line given as a prefix-count using linewise
-- [count]gbc - Toggles the number of line given as a prefix-count using blockwise
-- gc[count]{motion} - (Op-pending) Toggles the region using linewise comment
-- gb[count]{motion} - (Op-pending) Toggles the region using blockwise comment
--
-- VISUAL mode
-- gc - Toggles the region using linewise comment
-- gb - Toggles the region using blockwise comment
