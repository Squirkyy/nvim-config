vim.g.knap_viewer = "zathura"
vim.g.knap_settings = {
  texoutputext = "pdf",
  textopdf = "pdflatex -interaction=nonstopmode -halt-on-error -synctex=1 %docroot%",
  output_directory = "./",
  docroot = vim.fn.expand("%:p"),  -- full path to the current file
}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>kc", function()
  require("knap").process_once()
end, vim.tbl_extend("force", opts, { desc = "Knap process once" }))

map("n", "<leader>kp", function()
  require("knap").toggle_autopreviewing()
end, vim.tbl_extend("force", opts, { desc = "Knap toggle auto-preview" }))

map("n", "<leader>kj", function()
  require("knap").forward_jump()
end, vim.tbl_extend("force", opts, { desc = "Knap forward jump" }))

map("n", "<leader>kx", function()
  require("knap").close_viewer()
end, vim.tbl_extend("force", opts, { desc = "Knap close viewer" }))

