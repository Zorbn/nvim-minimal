--[[ Tabs ]]--
local tab_width = 4
vim.opt.tabstop = tab_width
vim.opt.shiftwidth = tab_width
vim.opt.softtabstop = tab_width
vim.opt.expandtab = true
vim.cmd([[
augroup prewrites
    autocmd!
        autocmd BufWritePre * :exe 'keepjumps | norm m`' | %s/\s\+$//e | norm g``
augroup END
]])

--[[ Aesthetics ]]--
vim.opt.guifont = "Consolas:h10"
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

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
                    "c_sharp", "cpp", "javascript", "typescript", "python", -- Additional parsers.
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                },
            }
        end
    },
    --[[ General ]]--
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("leap").add_default_mappings()
        end
    },
    "tpope/vim-repeat",
    "ap/vim-buftabline",
    --[[ Aesthetics ]]--
    {
        "kaiuri/nvim-juliana",
        config = function()
            require("nvim-juliana").setup()
            vim.cmd([[
                colorscheme juliana
                hi LineNr guifg=#a6adb9 guibg=#303841
                hi CursorLineNr guifg=#d8dee9
            ]])
        end
    },
    -- {
    --     "marko-cerovac/material.nvim",
    --     config = function()
    --         vim.g.material_style = "palenight"

    --         local colors = require("material.colors")
    --         require("material").setup({
    --             contrast = {
    --                 terminal = true,
    --                 sidebars = true,
    --                 floating_windows = true,
    --                 cursor_line = true,
    --             },
    --             custom_highlights = {
    --                 TabLineFill = { bg = colors.editor.bg_alt },
    --                 MsgArea = { bg = colors.editor.bg_alt },
    --                 Normal = { fg = colors.editor.fg, bg = colors.editor.bg, sp = colors.editor.bg_alt }
    --             },
    --             custom_colors = function(colors)
    --                 colors.editor.accent = colors.main.purple
    --             end
    --         })

    --         vim.cmd("colorscheme material")
    --     end
    -- },
    --[[ Language integration ]]--
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",

            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
        },
        lazy = false,
        config = function()
            -- Completion
            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert {
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<cr>"] = cmp.mapping.confirm { select = false },
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })

            -- LSP
            require("mason").setup()
            local mason_lsp = require("mason-lspconfig")
            mason_lsp.setup()
            local lspconfig = require("lspconfig")

            local on_attach = function(client, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                local bufopts = {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                }

                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set("n", "<leader>wl", function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, bufopts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, bufopts)

                vim.opt.signcolumn = "yes"
            end

            vim.diagnostic.config {
                virtual_text = false,
            }

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    signs = true,
                    update_in_insert = false,
                    underline = true,
                }
            )

            local client_capabilities = vim.lsp.protocol.make_client_capabilities()
            local capabilities = require("cmp_nvim_lsp").default_capabilities(client_capabilities)

            mason_lsp.setup_handlers({
                function (server)
                    lspconfig[server].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end
            })
        end
    }
}, {
    ui = {
        icons = {
            cmd = "",
            config = "",
            event = "",
            ft = "",
            init = "",
            keys = "",
            plugin = "",
            runtime = "",
            source = "",
            start = "",
            task = "",
            lazy = "",
        },
    },
})
