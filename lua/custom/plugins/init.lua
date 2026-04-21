-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec

-- ### Custom settings start here ###
-- https://tech.aptpod.co.jp/entry/2024/12/24/110000
-- https://zenn.dev/vim_jp/articles/1b4344e41b9d5b
-- https://zenn.dev/forcia_tech/articles/202411_deguchi_neovim

vim.g.mapleader = ' '
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorcolumn = true

vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { silent = true, desc = 'Quit ALL' })
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', ';', ':')

-- don't yank on single-char delete/substitute
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set('n', 'X', '"_X')
vim.keymap.set({ 'n', 'x' }, 's', '"_s') -- optional: 's' (= 'cl')
-- operator-pending maps (works like d/c but to black hole)
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'black hole delete' })
-- vim.keymap.set({ 'n', 'x' }, '<leader>c', '"_c', { desc = 'black hole change' })
vim.keymap.set('n', '<leader>D', '"_dd', { desc = 'black hole delete line' })

-- Move Tab
vim.keymap.set('n', '<PageUp>', '<cmd>bprev<CR>')
vim.keymap.set('n', '<PageDown>', '<cmd>bnext<CR>')

-- Move Window
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')

-- Terminal-mode: go to the window ABOVE
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { silent = true, desc = 'Terminal: focus left window' })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { silent = true, desc = 'Terminal: focus right window' })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { silent = true, desc = 'Terminal: focus below window' })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { silent = true, desc = 'Terminal: focus window above' })

-- Move cursor by Alt+hjkl
vim.keymap.set("i", "<M-h>", "<Left>",  {silent=true, desc="Insert: left"})
vim.keymap.set("i", "<M-l>", "<Right>",  {silent=true, desc="Insert: right"})
vim.keymap.set("i", "<M-j>", "<Down>", {silent=true, desc="Insert: down (wrap-aware)"})
vim.keymap.set("i", "<M-k>", "<Up>", {silent=true, desc="Insert: up (wrap-aware)"})

-- Open a bottom terminal while keeping nvim-tree on the left
vim.keymap.set('n', '<leader>te', function()
  -- If you're in NvimTree, move to the right window first
  if vim.bo.filetype == 'NvimTree' then
    vim.cmd 'wincmd l'
  end
  -- Open a 15-line terminal at the bottom
  vim.cmd 'botright 15split | terminal'
  -- Make the terminal nicer
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.cmd 'startinsert' -- jump straight into the shell
end, { desc = 'Open bottom terminal' })

-- Only in terminal *insert/job* mode: make <C-h> work as Backspace.
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function(ev)
    -- Clean up any prior terminal-local mappings for <C-h>
    pcall(vim.keymap.del, 't', '<C-h>', { buffer = ev.buf })
    pcall(vim.keymap.del, 'n', '<C-h>', { buffer = ev.buf }) -- ensure no local normal override

    -- t-mode (terminal job mode) only
    vim.keymap.set('t', '<C-h>', '<BS>', {
      buffer = ev.buf,
      noremap = true,
      silent = true,
      desc = 'Terminal(t): Backspace',
    })
  end,
})

-- Exit terminal-insert quickly with <Esc>
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { silent = true, desc = 'Terminal: enter Normal mode' })

-- Make <C-g> work like <Esc> (without touching Normal-mode default)
-- Insert/Visual/Select: leave to Normal
vim.keymap.set({ 'i', 'v', 'x', 's' }, '<C-g>', '<Esc>', { silent = true, desc = 'Ctrl-g as Escape' })
--e Terminal: leave terminal-job mode (equivalent to Esc for terminal)
vim.keymap.set('t', '<C-g>', [[<C-\><C-n>]], { silent = true, desc = 'Terminal: Ctrl-g as Escape' })
-- Command-line: cancel the current command (Esc behavior)
vim.keymap.set('c', '<C-g>', '<C-c>', { silent = true, desc = 'Cmdline: cancel' })
-- Optional: also override in Normal mode (disables default file-status on <C-g>)
-- vim.keymap.set("n", "<C-g>", "<Esc>", { silent = true, desc = "Normal: Ctrl-g as Escape" })


-- When inactive (tmux pane loses focus): fixed gray #3d3d3d for bg and split borders (see tmux-focus-events.lua)
-- NvimTree: Normal*, NvimTreeWinSeparator (winhighlight); WinSeparator is the global vertical split line.
local INACTIVE_HL_GROUPS = {
  'Normal',
  'NormalNC', -- non-current windows (e.g. editor while cursor is in NvimTree)
  'NvimTreeNormal',
  'NvimTreeNormalNC',
  'NvimTreeNormalFloat',
  'WinSeparator',
  'NvimTreeWinSeparator',
  'VertSplit', -- legacy themes; harmless if unused
}

--- Use fg for split lines (WinSeparator / VertSplit); bg for Normal* fills.
local INACTIVE_USE_FG = {
  WinSeparator = true,
  NvimTreeWinSeparator = true,
  VertSplit = true,
}

--- nvim-tree.lua appearance defaults (restore transparent / linked groups)
local TREE_LINK_RESTORE = {
  NvimTreeNormal = { link = 'Normal' },
  NvimTreeNormalNC = { link = 'NvimTreeNormal' },
  NvimTreeNormalFloat = { link = 'NormalFloat' },
  NvimTreeWinSeparator = { link = 'WinSeparator' },
}

---@type table<string, { orig_bg: integer|nil, orig_fg: integer|nil }>
local hl_inactive_snap = {}

local function save_inactive_hl()
  hl_inactive_snap = {}
  for _, name in ipairs(INACTIVE_HL_GROUPS) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false, create = false })
    if ok and hl then
      hl_inactive_snap[name] = { orig_bg = hl.bg, orig_fg = hl.fg }
    end
  end
end

-- Inactive pane background: darker neutral gray
local INACTIVE_BG_GRAY = 0x222222

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = save_inactive_hl,
})
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = save_inactive_hl,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = save_inactive_hl,
})
vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    if next(hl_inactive_snap) == nil then
      save_inactive_hl()
    end
    for _, name in ipairs(INACTIVE_HL_GROUPS) do
      local st = hl_inactive_snap[name]
      if st then
        if INACTIVE_USE_FG[name] then
          vim.api.nvim_set_hl(0, name, { fg = INACTIVE_BG_GRAY })
        else
          vim.api.nvim_set_hl(0, name, { bg = INACTIVE_BG_GRAY })
        end
      end
    end
  end,
})
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    for _, name in ipairs(INACTIVE_HL_GROUPS) do
      local st = hl_inactive_snap[name]
      if st then
        if INACTIVE_USE_FG[name] then
          local attrs = {}
          if st.orig_fg then
            attrs.fg = st.orig_fg
          end
          if st.orig_bg then
            attrs.bg = st.orig_bg
          end
          if next(attrs) then
            vim.api.nvim_set_hl(0, name, attrs)
          elseif name == 'NvimTreeWinSeparator' then
            vim.api.nvim_set_hl(0, name, TREE_LINK_RESTORE.NvimTreeWinSeparator)
          elseif name == 'WinSeparator' or name == 'VertSplit' then
            pcall(vim.cmd, 'highlight clear ' .. name)
          end
        elseif st.orig_bg then
          vim.api.nvim_set_hl(0, name, { bg = st.orig_bg })
        elseif name == 'Normal' then
          vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
        elseif name == 'NormalNC' then
          vim.api.nvim_set_hl(0, 'NormalNC', { link = 'Normal' })
        elseif TREE_LINK_RESTORE[name] then
          vim.api.nvim_set_hl(0, name, TREE_LINK_RESTORE[name])
        else
          vim.api.nvim_set_hl(0, name, { bg = 'NONE' })
        end
      end
    end
  end,
})

-- Brighten comment color (tokyonight-night default is too dark)
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'Comment', { fg = '#7c8fa8', italic = false })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#7c8fa8' })
  end,
})

-- ### Custom settings end here ###

return {}
