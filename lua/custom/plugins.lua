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
  ft = { "tex", "markdown", "plaintex", "typst" },
  config = function()
    require("custom.configs.knap")
  end,
},
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  
  -- This is the new config function that ties everything together
  config = function()
    -- 1. Get your custom settings from the file we just edited
    local lsp_settings = require "plugins.configs.lspconfig"

    -- 2. Define your list of servers
    local servers = { 
      "clangd", 
      "lua_ls"
      -- Add more here, e.g. "pyright", "tsserver"
    }

    -- 3. Set up mason-lspconfig to install them
    require("mason-lspconfig").setup {
      ensure_installed = servers,
      automatic_installation = true,
    }

    -- 4. Manually set up each server using your custom settings
    require("mason-lspconfig").setup_handlers {
      
      -- This is the default handler for any server
      -- you don't customize below
      function(server_name)
        require("lspconfig")[server_name].setup {
          on_attach = lsp_settings.on_attach,
          capabilities = lsp_settings.capabilities,
        }
      end,
      
      -- Custom handler for lua_ls
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup {
          on_attach = lsp_settings.on_attach,
          capabilities = lsp_settings.capabilities,
          settings = lsp_settings.lua_ls_settings, -- Uses your exported settings
        }
      end,
      
      -- Custom handler for clangd
      ["clangd"] = function()
        require("lspconfig").clangd.setup {
          on_attach = lsp_settings.clangd_on_attach, -- Uses your exported on_attach
          capabilities = lsp_settings.capabilities,
        }
      end,
    }
  end,
} 

}

return plugins
