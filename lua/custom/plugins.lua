local plugins = {
  {
    "p00f/clangd_extensions.nvim",
    after = "nvim_lspconfig",
    config = function ()
      require "custom.configs.clangd_extensions"
    end,
  },
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
              "clangd",
              "clang-format",
          }
      },
  },
  {
      "rust-lang/rust.vim",
      ft = "rust",
      init = function ()
          vim.g.rustfmt_autosave = 1
          -- vim.api.nvim_exec([[autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = true })]], false)
      end
  },
  {
      "mrcjkb/rustaceanvim",
      ft = "rust",
      config = function ()
          return require "custom.configs.rustaceanvim"
      end,
  },
  {
      "NvChad/nvterm",
      config = function()
          require("nvterm").setup({
              terminals = {
                  shell = vim.o.shell,
              },
          })
      end,
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Yazi" },
    lazy = false,
    config = function()
      require("custom.configs.yazi")
    end,
  },
{
  "frabjous/knap",
  ft = { "tex", "markdown", "plaintex" },
  config = function()
    require("custom.configs.knap")
  end,
}

}

return plugins
