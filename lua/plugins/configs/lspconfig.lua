-- dofile(vim.g.base46_cache .. "lsp")
--
-- local M = {}
-- local utils = require "core.utils"
--
-- -- export on_attach & capabilities for custom lspconfigs
--
-- M.on_attach = function(client, bufnr)
--   utils.load_mappings("lspconfig", { buffer = bufnr })
--
--   if client.server_capabilities.signatureHelpProvider then
--     require("nvchad.signature").setup(client)
--   end
--
--   if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
--     client.server_capabilities.semanticTokensProvider = nil
--   end
-- end
--
-- M.capabilities = vim.lsp.protocol.make_client_capabilities()
--
-- M.capabilities.textDocument.completion.completionItem = {
--   documentationFormat = { "markdown", "plaintext" },
--   snippetSupport = true,
--   preselectSupport = true,
--   insertReplaceSupport = true,
--   labelDetailsSupport = true,
--   deprecatedSupport = true,
--   commitCharactersSupport = true,
--   tagSupport = { valueSet = { 1 } },
--   resolveSupport = {
--     properties = {
--       "documentation",
--       "detail",
--       "additionalTextEdits",
--     },
--   },
-- }
--
-- vim.lsp.config.lua_ls = {
--   on_attach = M.on_attach,
--   capabilities = M.capabilities,
--
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { "vim" },
--       },
--       workspace = {
--         library = {
--           [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--           [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--           [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
--           [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
--         },
--         maxPreload = 100000,
--         preloadFileSize = 10000,
--       },
--     },
--   },
-- }
--
-- vim.lsp.config.clangd = {
--   on_attach = function (client, bufnr)
--     client.server_capabilities.signatureHelpProvider = false
--     M.on_attach(client, bufnr) -- Make sure this calls M.on_attach
--
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       group = vim.api.nvim_create_augroup("FormatOnSave", {clear = true}),
--       buffer = bufnr,
--       callback = function ()
--         vim.lsp.buf.format({ bufnr = bufnr})
--       end,
--     })
--   end,
--   capabilities = M.capabilities,
-- }
--
-- return M
--
dofile(vim.g.base46_cache .. "lsp")

local M = {}
local utils = require "core.utils"

-- 1. Define the base on_attach and capabilities
M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- 2. Define and export settings for lua_ls
M.lua_ls_settings = {
  Lua = {
    diagnostics = {
      globals = { "vim" },
    },
    workspace = {
      library = {
        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
        [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
}

-- 3. Define and export the custom on_attach for clangd
M.clangd_on_attach = function (client, bufnr)
  client.server_capabilities.signatureHelpProvider = false
  M.on_attach(client, bufnr) -- Call the base on_attach

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("FormatOnSave", {clear = true}),
    buffer = bufnr,
    callback = function ()
      vim.lsp.buf.format({ bufnr = bufnr})
    end,
  })
end

-- 4. Just return the table M
return M
