return {
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    lazy = false, -- the plugin lazy-loads itself on rust filetypes
    init = function()
      -- a function, so cmp_nvim_lsp is only required when the server starts
      vim.g.rustaceanvim = function()
        return {
          server = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          },
        }
      end
    end,
  },
}
