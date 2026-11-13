return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", desc = "Find all" },
      { "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help page" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Find oldfiles" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Find in current buffer" },
      { "<leader>cm", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
      { "<leader>gt", "<cmd>Telescope git_status<CR>", desc = "Git status" },
      { "<leader>ma", "<cmd>Telescope marks<CR>", desc = "Telescope bookmarks" },
    },
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg", "-L", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = { "node_modules" },
        path_display = { "truncate" },
        winblend = 0,
        color_devicons = true,
        set_env = { COLORTERM = "truecolor" },
        mappings = {
          n = { ["q"] = function(...) return require("telescope.actions").close(...) end },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "lua", "c", "cpp", "rust", "zig", "vhdl", "markdown", "markdown_inline",
        "vim", "vimdoc", "query", "typst", "toml", "json", "yaml", "bash",
      }

      -- parser installation needs the tree-sitter CLI (installed via Mason, see :MasonInstallAll)
      if vim.fn.executable "tree-sitter" == 1 then
        require("nvim-treesitter").install(parsers)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { fast_wrap = {}, disable_filetype = { "TelescopePrompt", "vim" } },
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip", dependencies = "rafamadriz/friendly-snippets" },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      luasnip.config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

      cmp.setup {
        completion = { completeopt = "menu,menuone" },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = require("lspkind").cmp_format { mode = "symbol_text", maxwidth = 50 },
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
      }
    end,
  },
}

