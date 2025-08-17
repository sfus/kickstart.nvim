-- Make <C-g> close Telescope regardless of prompt mode or window
return {
  {
    'nvim-telescope/telescope.nvim',

    -- Extend (and force) mappings in Telescope's own setup: i/n modes
    opts = function(_, opts)
      local actions = require 'telescope.actions'
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.defaults.mappings = opts.defaults.mappings or {}

      for _, mode in ipairs { 'i', 'n' } do
        opts.defaults.mappings[mode] = opts.defaults.mappings[mode] or {}
        -- Always override: <C-g> behaves like <Esc> (close)
        opts.defaults.mappings[mode]['<C-g>'] = actions.close
      end

      return opts
    end,

    -- Also add buffer-local maps in ANY mode for both TelescopePrompt/Results
    -- so it works even if you're not in insert/normal (edge cases).
    init = function()
      -- Global keymap: open registers picker (lazy-load on use)
      vim.keymap.set('n', '<leader>s"', function()
        require('telescope.builtin').registers()
      end, { desc = '[S]earch Registers' })

      local group = vim.api.nvim_create_augroup('TelescopeCtrlGClose', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { 'TelescopePrompt', 'TelescopeResults' },
        callback = function(ev)
          local actions = require 'telescope.actions'
          local state = require 'telescope.actions.state'

          local function close_picker()
            local picker = state.get_current_picker(ev.buf)
            local pbuf = picker and picker.prompt_bufnr or ev.buf
            actions.close(pbuf)
          end

          for _, mode in ipairs { 'i', 'n', 'v', 'x', 's' } do
            vim.keymap.set(mode, '<C-g>', close_picker, {
              buffer = ev.buf,
              silent = true,
              nowait = true,
              desc = 'Telescope: close (<C-g>)',
            })
          end
        end,
      })
    end,
  },
}
