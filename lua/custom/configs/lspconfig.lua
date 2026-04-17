local lspconfig = require("lspconfig")
local default_settings = require("plugins.configs.lspconfig")

lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    -- Disable standard signature help (if you use clangd_extensions)
    client.server_capabilities.signatureHelpProvider = false
    
    -- Call NvChad's default on_attach
    default_settings.on_attach(client, bufnr)

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end,
  capabilities = default_settings.capabilities,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})
