return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    opts = {
      preview = {
        -- icon_provider = "internal",
        icon_provider = "devicons",
      },
    },

    config = function(_, opts)
      require("markview").setup(opts)

      -- optional keymaps
      vim.keymap.set("n", "<leader>mv", "<cmd>Markview toggle<CR>", { desc = "Toggle Markview" })
      vim.keymap.set("n", "<leader>mo", "<cmd>Markview open<CR>", { desc = "Open Markview" })
    end,
  },
}