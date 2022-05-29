vim.g.monokaipro_filter = "classic"
vim.g.monokaipro_flat_term = true
vim.cmd("colorscheme monokaipro")

-- Match terminal background color regardless of colorscheme
-- vim.highlight.create("Normal", { guibg=0 }, false)
-- vim.highlight.create("StatusLine", { guibg=0 }, false)

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.shell = "pwsh"
vim.opt.shortmess = vim.opt.shortmess + "I"

vim.opt.equalalways = false
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Highlight trailing whitespace
vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + "trail:·"

map = vim.api.nvim_set_keymap

-- Escape terminal easier (it's Ctrl-\ because \ is the prefix for escape characters)
map("t", "<C-\\>", "<C-\\><C-n>", { noremap = true })

-- GUI
vim.g.neovide_refresh_rate = 165
vim.opt.guifont = "mononoki:h11"
