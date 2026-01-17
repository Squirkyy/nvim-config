local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- The require("lspconfig") line is gone

vim.lsp.config.clangd = { -- ⬅️ 2. NOW IT'S CORRECT
  on_attach = function (client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("FormatOnSave", {clear = true}),
      buffer = bufnr,
      callback = function ()
        vim.lsp.buf.format({ bufnr = bufnr})
      end,
    })
  end,
  capabilities = capabilities,
}
