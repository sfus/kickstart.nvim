-- Switch to fwcd's kotlin-language-server (disable JetBrains kotlin-lsp)
return {
  -- Ensure the fwcd server is installed via Mason
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}

      -- remove kotlin-lsp if it was previously ensured
      for i = #opts.ensure_installed, 1, -1 do
        if opts.ensure_installed[i] == "kotlin-lsp" then
          table.remove(opts.ensure_installed, i)
        end
      end

      -- add fwcd kotlin_language_server
      if not vim.tbl_contains(opts.ensure_installed, "kotlin_language_server") then
        table.insert(opts.ensure_installed, "kotlin_language_server")
      end
      return opts
    end,
  },

  -- Configure lspconfig for fwcd server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Explicitly disable JetBrains kotlin-lsp if it exists in your config
        kotlin_lsp = nil,

        kotlin_language_server = {
          single_file_support = true, -- works with standalone files too
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "settings.gradle.kts", "settings.gradle",
              "build.gradle.kts",    "build.gradle",
              "pom.xml",
              ".git"
            )(fname)
          end,
          -- If you need a specific JDK:
          -- cmd_env = { JAVA_HOME = "/path/to/jdk-17" },
        },
      },
    },
  },
}
