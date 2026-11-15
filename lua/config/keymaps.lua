local map = vim.keymap.set

-- insert mode: navigation
map("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- normal mode
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", "<leader>N", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>fm", function()
  vim.lsp.buf.format { async = true }
end, { desc = "LSP formatting" })

-- move through wrapped lines (but not with counts / operators)
local wrapped_j = 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"'
local wrapped_k = 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"'
map({ "n", "x" }, "j", wrapped_j, { desc = "Move down", expr = true })
map({ "n", "x" }, "k", wrapped_k, { desc = "Move up", expr = true })
map({ "n", "v" }, "<Down>", wrapped_j, { desc = "Move down", expr = true })
map({ "n", "v" }, "<Up>", wrapped_k, { desc = "Move up", expr = true })

-- terminal / visual
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
map("v", "<", "<gv", { desc = "Indent line" })
map("v", ">", ">gv", { desc = "Indent line" })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })

-- buffers
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Goto next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Goto prev buffer" })
map("n", "<leader>x", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "terminal" then
    vim.cmd "hide"
    return
  end
  if #vim.fn.getbufinfo { buflisted = 1 } > 1 then
    vim.cmd "bprevious"
  end
  vim.cmd("bdelete! " .. buf)
end, { desc = "Close buffer" })

-- commenting (uses neovim's builtin gc / gcc)
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- which-key
map("n", "<leader>wK", "<cmd>WhichKey<CR>", { desc = "Which-key all keymaps" })
map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "Which-key query lookup" })

