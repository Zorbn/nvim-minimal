--[[ Tabs ]]--
local tab_width = 4
vim.opt.tabstop = tab_width
vim.opt.shiftwidth = tab_width
vim.opt.softtabstop = tab_width
vim.opt.expandtab = true

--[[ Aesthetics ]]--
vim.opt.guifont = "Consolas:h10"
vim.opt.number = true
vim.opt.termguicolors = true

if vim.fn.has("gui_running") == 1 then
    vim.opt.background = "light"
end

--[[ Powershell ]]--
if vim.fn.has("win32") then
    vim.opt.shell = "pwsh"
    vim.opt.shellxquote = ""
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellpipe = "| Out-File -Encoding UTF8 %s"
    vim.opt.shellredir = "| Out-File -Encoding UTF8 %s"
end

--[[ General keymaps ]]--
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { remap = false })
vim.keymap.set("n", "<C-l>", "<cmd>bnext<cr>", { remap = false })
vim.keymap.set("n", "<C-h>", "<cmd>bprev<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>t", ":tabnew ", { remap = false })

--[[ Packages ]]--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.install").prefer_git = false
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query", -- Overwrite the default nvim parsers with nvim-treesitter ones.
                    "c_sharp", "cpp", "javascript", "typescript", -- Additional parsers.
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                },
            }
        end
    },
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("leap").add_default_mappings()
        end
    },
    "tpope/vim-repeat",
    "ap/vim-buftabline",
    {
        url = "https://git.sr.ht/~p00f/alabaster.nvim",
        config = function()
            vim.cmd("colorscheme alabaster")
        end
    },
}, {
    ui = {
        icons = {
            cmd = "C",
            config = "C",
            event = "E",
            ft = "F",
            init = "I",
            keys = "K",
            plugin = "P",
            runtime = "R",
            source = "S",
            start = "S",
            task = "T",
            lazy = "L ",
        },
    },
})
