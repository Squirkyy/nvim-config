-- Terminals (replaces NvChad/nvterm)
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermNew" },
    keys = {
      { "<A-i>", "<cmd>1ToggleTerm direction=float<CR>", mode = { "n", "t" }, desc = "Toggle floating term" },
      { "<A-h>", "<cmd>2ToggleTerm direction=horizontal<CR>", mode = { "n", "t" }, desc = "Toggle horizontal term" },
      { "<A-v>", "<cmd>3ToggleTerm direction=vertical<CR>", mode = { "n", "t" }, desc = "Toggle vertical term" },
      { "<leader>h", "<cmd>TermNew direction=horizontal<CR>", desc = "New horizontal term" },
      { "<leader>v", "<cmd>TermNew direction=vertical<CR>", desc = "New vertical term" },
    },
    opts = {
      shell = vim.o.shell,
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      float_opts = { border = "curved" },
    },
  },
}

