-- PLUGINS
-- Installs plugins and configures them

vim.pack.add({
    -- BEGIN EXPERIMENTAL PLUGINS
    { src = 'https://github.com/mfussenegger/nvim-jdtls' },
    { src = 'https://github.com/Saghen/blink.cmp' },
    -- END EXPERIMENTAL PLUGINS
    -- Neogit (git integration)
    { src = 'https://github.com/NeogitOrg/neogit' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },  -- Dependency of neogit
    { src = 'https://github.com/sindrets/diffview.nvim' }, -- Diff integration (dependency of neogit)
    -- Plugin to handle terminals
    { src = 'https://github.com/akinsho/toggleterm.nvim' },
    -- File manager that doesn't suck (netrw)
    { src = 'https://github.com/stevearc/oil.nvim' },
    -- For the Pick function
    { src = 'https://github.com/echasnovski/mini.pick' },
    -- For installing LSP servers automatically
    { src = 'https://github.com/mason-org/mason.nvim' },
    -- For automatic LSP configuration
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    -- For better syntax highlighting
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    -- Colorscheme
    { src = "https://github.com/folke/tokyonight.nvim" },
    -- Snippet engine
    { src = "https://github.com/L3MON4D3/LuaSnip" },
})

require('blink.cmp').setup({
    cmdline = {
        enabled = true,
        keymap = {
            preset = 'cmdline',
            ['<Tab>'] = { 'select_and_accept' },
        },
        completion = { menu = { auto_show = true } },
    },
    completion = {
        accept = { auto_brackets = { enabled = true }, },
        menu = { auto_show = true },
        completion = { documentation = { auto_show = true } },
        ghost_text = {
            enabled = true,
            show_with_menu = true,
        },
    },
    fuzzy = { implementation = "lua" },
    keymap = { preset = 'default' },
})

require('neogit').setup({})

require("oil").setup({
    keymaps = {
        ["<C-p>"] = { "actions.preview", opts = { split = "botright" } }
    },
    skip_confirm_for_simple_edits = true,
    natural_order = true,
    float = {
        preview_split = "right",
    },
    preview_win = {
        preview_split = "right",
    }
})
require('luasnip').setup({ enable_autosnippets = true })
require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets" })

require("toggleterm").setup({
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            -- half of avaliable screen
            return vim.o.columns * 0.5
        end
    end,
    close_on_exit = true,
    auto_scroll = true,
    shade_terminals = true,
})

-- Sets colorscheme
vim.cmd('colorscheme tokyonight')

-- Treesitter
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "lua", "vim", "vimdoc" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,
    },

    modules = {}
}

require("mason").setup()

-- For fuzzy finder
require("mini.pick").setup()

-- Enable desired LSPs
-- Note that their configs are in nvim/lsp/*
-- Go there if you want to make changes to them
vim.lsp.enable({
    "jsonls",
    "lua_ls",
    "rust_analyzer",
    "rnix",
    "slint-lsp",
})
