local opt = vim.opt

vim.g.mapleader = " "

opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

opt.shortmess:append "sI" -- disable intro
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250
opt.winborder = "rounded"

-- go to previous/next line with h,l,left arrow and right arrow
opt.whichwrap:append "<>[]hl"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- filetypes
vim.filetype.add { extension = { typ = "typst" } }

-- diagnostics
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
}

-- make Mason-installed binaries (LSPs, tree-sitter CLI) available right at startup
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (vim.fn.has "win32" == 1 and ";" or ":") .. vim.env.PATH
