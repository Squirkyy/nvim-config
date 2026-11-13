return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" }, -- night / storm / moon / day
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme "tokyonight"
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
        },
      },
    },
  },

  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = true },
      exclude = {
        filetypes = {
          "help", "terminal", "lazy", "lspinfo", "TelescopePrompt",
          "TelescopeResults", "mason", "toggleterm", "",
        },
        buftypes = { "terminal" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cmd = "WhichKey",
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local function map(lhs, rhs, desc, opts)
          vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", { buffer = bufnr, desc = desc }, opts or {}))
        end

        map("]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gs.nav_hunk "next"
          end
        end, "Jump to next hunk")
        map("[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gs.nav_hunk "prev"
          end
        end, "Jump to prev hunk")

        map("<leader>rh", gs.reset_hunk, "Reset hunk")
        map("<leader>ph", gs.preview_hunk, "Preview hunk")
        map("<leader>gb", gs.blame_line, "Blame line")
        map("<leader>td", gs.toggle_deleted, "Toggle deleted")
      end,
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvimtree" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus nvimtree" },
    },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = { side = "left", width = 30, preserve_window_proportions = true },
      git = { enable = false },
      renderer = {
        root_folder_label = false,
        highlight_git = false,
        icons = { show = { git = false } },
      },
    },
  },

  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    keys = { { "<leader>n", "<cmd>Yazi<CR>", desc = "Yazi File Manager" } },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}

