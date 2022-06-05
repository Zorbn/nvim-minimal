require("plugins")

vim.opt.termguicolors = true
vim.cmd("colorscheme gourd")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.shell = "pwsh"

vim.g.netrw_banner = 0
vim.g.netrw_menu = 0
vim.opt.shortmess = vim.opt.shortmess + "I"
vim.opt.laststatus = 3

vim.opt.equalalways = false
vim.opt.splitbelow = true
vim.opt.splitright = true

map = vim.api.nvim_set_keymap

-- Escape terminal easier (it's Ctrl-\ because \ is the prefix for escape characters)
map("t", "<C-\\>", "<C-\\><C-n>", { noremap = true })


-- Highlight trailing whitespace
vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + "trail:·"

-- Match terminal background color regardless of colorscheme
-- vim.highlight.create("Normal", { guibg=0 }, false)
-- vim.highlight.create("StatusLine", { guibg=0 }, false)
