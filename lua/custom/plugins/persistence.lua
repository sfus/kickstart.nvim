return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  init = function()
    if vim.fn.argc() == 0 then
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          pcall(vim.cmd, 'NvimTreeClose')
        end,
      })
      require('persistence').load()
      -- Close NvimTree windows restored from session
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.fn.bufname(buf):match('NvimTree_') then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
      -- Delete NvimTree buffers restored from session
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.bufname(buf):match('NvimTree_') then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
      -- Open NvimTree after session is fully restored
      vim.schedule(function()
        pcall(require('nvim-tree.api').tree.open)
      end)
    end
  end,
}
