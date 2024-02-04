local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      require("lsp-inlayhints").on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  },
}

require("lsp-inlayhints").setup({
  inlay_hints = {
    parameter_hints = {
      show = true,
      prefix = "<- ",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = true,
    },
    type_hints = {
      -- type and other hints
      show = true,
      prefix = "=> ",
      separator = ", ",
      remove_colon_start = true,
      remove_colon_end = false,
    },
    only_current_line = false,
    -- separator between types and parameter hints. Note that type hints are
    -- shown before parameter
    labels_separator = "  ",
    -- whether to align to the length of the longest line in the file
    max_len_align = false,
    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,
    -- highlight group
    highlight = "Comment",
  },
  debug_mode = true,
})
