return {
  {
    'Mofiqul/dracula.nvim',
    priority = 999, -- lower than tokyonight (1000) to load after and override colorscheme
    config = function()
      vim.cmd.colorscheme 'dracula'
    end,
  },
}
