local yazi = require("yazi")

yazi.setup()

-- Optional: Add key mapping for launching Yazi
vim.keymap.set("n", "<leader>n", "<cmd>Yazi<CR>", { desc = "Yazi File Manager" })
