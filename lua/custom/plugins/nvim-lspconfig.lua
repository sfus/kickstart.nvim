-- Extra LSP keymaps for ALL LSP buffers (Kickstart style: attach buffer-locally)
return {
  {
    'neovim/nvim-lspconfig',
    init = function()
      local aug = vim.api.nvim_create_augroup('UserLspKeysAll', { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = aug,
        callback = function(args)
          local bufnr = args.buf

          -- Use Telescope pickers when available; fallback to plain LSP funcs
          local tb
          ok, _ = nil, nil
          ok = pcall(function()
            tb = require 'telescope.builtin'
          end)

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- ── Go to / Peek / Lists ───────────────────────────────────────────
          map('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to definition')
          map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to declaration')
          map('n', 'gI', vim.lsp.buf.implementation, 'LSP: Go to implementation')
          map('n', 'gy', vim.lsp.buf.type_definition, 'LSP: Go to type definition')
          map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover docs')
          if ok and tb then
            map('n', 'gr', tb.lsp_references, 'LSP: References (Telescope)')
            map('n', '<leader>sd', tb.lsp_definitions, 'LSP: Definitions (Telescope)')
          else
            map('n', 'gr', vim.lsp.buf.references, 'LSP: References')
          end

          -- ── Edits / Code actions ───────────────────────────────────────────
          map('n', '<leader>cr', vim.lsp.buf.rename, 'LSP: Rename symbol')
          map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code action')
          map('n', '<leader>co', function()
            vim.lsp.buf.code_action {
              context = { only = { 'source.organizeImports' } },
              apply = true, -- no-op if server doesn't support it
            }
          end, 'LSP: Organize imports')

          -- ── Diagnostics ────────────────────────────────────────────────────
          map('n', '[d', vim.diagnostic.goto_prev, 'Diag: Previous')
          map('n', ']d', vim.diagnostic.goto_next, 'Diag: Next')
          map('n', '<leader>cd', vim.diagnostic.open_float, 'Diag: Line diagnostics')
          map('n', '<leader>cq', vim.diagnostic.setloclist, 'Diag: To loclist')

          -- ── Formatting (useful if you don't rely on conform.nvim) ─────────
          map('n', '<leader>cf', function()
            vim.lsp.buf.format { async = true }
          end, 'LSP: Format buffer')
        end,
      })
    end,
  },
}
