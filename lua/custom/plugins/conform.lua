-- Change format_on_save to false
return {
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts = opts or {}
      opts.format_on_save = false
      return opts
    end,
  },
}
