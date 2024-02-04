local plugins = {
  {
      "neovim/nvim-lspconfig",
      config = function()
          require "plugins.configs.lspconfig"
          require "custom.configs.lspconfig"
      end,
  },
  {
      "williamboman/mason.nvim",
      opts = {
          ensure_installed = {
              "rust-analyzer",
              "typescript-la",
              "eslint-lsp",
          },
      },
  },
  {
      "rust-lang/rust.vim",
      ft = "rust",
      init = function ()
          vim.g.rustfmt_autosave = 1
      end
  },
  {
      "mrcjkb/rustaceanvim",
      ft = "rust",
      dependencies = {
          {
              "lvimuser/lsp-inlayhints.nvim",
              opts = {}
          },
          "neovim/nvim-lspconfig",
      },
      config = function ()
          return require "custom.configs.rustaceanvim"
      end,
  },
  {
      "NvChad/nvterm",
      config = function()
          local isWindows = vim.fn.has("win32") == 1
          local default_shell = "/usr/bin/zsh" -- Default to zsh for Linux

          if isWindows then
              default_shell = "powershell" -- Switch to PowerShell for Windows
          end

          require("nvterm").setup({
              terminals = {
                  shell = default_shell,
                  -- The rest of your nvterm configuration goes here
              },
              -- Additional nvterm configurations can be added here
          })
      end,
  },
}

return plugins
