-- Typst: live preview in the browser (LSP is tinymist, see lsp.lua)
return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function()
      require("typst-preview").update()
    end,
    keys = {
      { "<leader>tp", "<cmd>TypstPreviewToggle<CR>", ft = "typst", desc = "Typst preview toggle" },
    },
    opts = {
      dependencies_bin = { tinymist = "tinymist" }, -- use the Mason-installed tinymist
    },
  },
}

