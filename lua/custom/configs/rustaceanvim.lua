local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      -- Native Neovim 0.11 inlay hints support
      if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
    capabilities = capabilities,
  },
}
