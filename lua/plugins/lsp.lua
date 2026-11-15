-- Mason packages installed by :MasonInstallAll
local mason_packages = {
  "lua-language-server",
  "clangd",
  "rust-analyzer",
  "zls",        -- Zig
  "rust_hdl",   -- VHDL (vhdl_ls)
  "tree-sitter-cli",
  "ltex-ls-plus", -- spell + grammar (de/en)
  "tinymist",     -- Typst
}

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },
      },
      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      require("mason").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(mason_packages, " "))
      end, { desc = "Install all configured Mason packages" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- capabilities for all servers (nvim-cmp completion)
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = { vim.env.VIMRUNTIME, vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy" },
              checkThirdParty = false,
            },
            hint = { enable = true },
          },
        },
      })

      require("config.ltex").setup()

      vim.lsp.config("tinymist", {
        settings = { formatterMode = "typstyle" },
      })

      -- mason-lspconfig enables every Mason-installed server (vim.lsp.enable),
      -- rust-analyzer is handled by rustaceanvim instead.
      require("mason-lspconfig").setup {
        automatic_enable = { exclude = { "rust_analyzer" } },
      }

      -- keymaps & features once a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local function map(mode, lhs, rhs, desc, opts)
            vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = bufnr, desc = desc }, opts or {}))
          end

          map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
          map("n", "gd", vim.lsp.buf.definition, "LSP definition")
          map("n", "K", vim.lsp.buf.hover, "LSP hover")
          map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
          map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
          map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP definition type")
          map("n", "<leader>ra", vim.lsp.buf.rename, "LSP rename")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
          map("n", "gr", vim.lsp.buf.references, "LSP references", { nowait = true })
          map("n", "<leader>lf", function()
            vim.diagnostic.open_float { border = "rounded" }
          end, "Floating diagnostic")
          map("n", "[d", function()
            vim.diagnostic.jump { count = -1, float = { border = "rounded" } }
          end, "Goto prev diagnostic")
          map("n", "]d", function()
            vim.diagnostic.jump { count = 1, float = { border = "rounded" } }
          end, "Goto next diagnostic")
          map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic setloclist")
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")

          -- inlay hints (on by default, toggle with <leader>ih)
          if client and client:supports_method("textDocument/inlayHint", bufnr) then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            map("n", "<leader>ih", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
            end, "Toggle inlay hints")
          end

          -- clangd: format on save
          if client and client.name == "clangd" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("FormatOnSave" .. bufnr, { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      })
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    opts = {},
  },
}
