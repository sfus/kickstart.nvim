return {
  'FabijanZulj/blame.nvim',
  opts = {
    date_format = "%Y-%m-%d %H:%M",
    relative_date_if_recent = false,
    format_fn = function(line_porcelain, config, idx)
      local hash = string.sub(line_porcelain.hash, 0, 7)
      if hash ~= "0000000" then
        local utils = require("blame.utils")
        local date_text = utils.format_time(config.date_format, line_porcelain.committer_time)
        return {
          idx = idx,
          values = {
            { textValue = hash, hl = "Comment" },
            { textValue = date_text, hl = hash },
            { textValue = string.sub(line_porcelain.author, 1, 10), hl = hash },
          },
          format = "%s %s %s",
        }
      else
        return {
          idx = idx,
          values = { { textValue = "Not committed", hl = "Comment" } },
          format = "%s",
        }
      end
    end,
  },
  keys = {
    { '<leader>gb', '<cmd>BlameToggle<cr>', desc = 'Toggle git [b]lame' },
  },
}
