require("plugins")

vim.opt.termguicolors = true
vim.opt.guifont = "Iosevka:h13"

vim.opt.expandtab = true
vim.opt.mouse = "a"

if vim.fn.has("win32") then
    vim.opt.shell = "pwsh"
    vim.opt.shellxquote = ""
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellpipe = "| Out-File -Encoding UTF8 %s"
    vim.opt.shellredir = "| Out-File -Encoding UTF8 %s"
end

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

-- File type dependent indentation
function real_tabs()
    vim.opt_local.expandtab = false
end

function space_tabs(width)
    vim.opt.tabstop = width
    vim.opt.shiftwidth = width
end

function add_file_callback(type, callback)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = type,
        callback = callback,
    })
end

space_tabs(4)
add_file_callback("go", real_tabs)
add_file_callback("make", real_tabs)
add_file_callback("ruby", function() space_tabs(2) end)

-- Match terminal background color regardless of colorscheme
vim.highlight.create("Normal", { guibg=0 }, false)
vim.highlight.create("StatusLine", { guibg=0 }, false)
