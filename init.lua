-- STATIC OPTIONS

vim.g.mapleader = ' '

-- Spacing
vim.opt.shiftwidth = 4;
vim.opt.signcolumn = "yes";
vim.opt.tabstop = 4;
vim.opt.expandtab = true;
vim.diagnostic.config(
    {
        virtual_text = true,
    }
);

-- Line numbering
vim.opt.number = true;
vim.opt.relativenumber = true;

-- PLUGINS
vim.pack.add({
    -- BEGIN EXPERIMENTAL PLUGINS
    { src = 'https://github.com/mluders/comfy-line-numbers.nvim' },
    -- END EXPERIMENTAL PLUGINS
    -- For the Pick function
    { src = 'https://github.com/echasnovski/mini.pick' },
    -- For installing LSP servers automatically
    { src = 'https://github.com/mason-org/mason.nvim' },
    -- For automatic LSP configuration
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

-- Put help text to right side instead of top
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = { "help" }, command = "wincmd L", }
)

vim.api.nvim_create_autocmd(
    "BufWritePre",
    { pattern = { "*.rs", "*.lua" }, callback = function() vim.lsp.buf.format({ async = false }) end }
)

function CloseHelpOrTmpWindow()
    local windows = vim.api.nvim_list_wins();
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
        if filetype == "help" then
            vim.api.nvim_win_close(win, false)
        end
    end
end

function RunCommandInTerminal()

end

-- BINDINGS

-- Shortcuts for common stuff
vim.keymap.set('n', '<leader>so', ':update<CR>:so ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>q', ':q')
vim.keymap.set('n', '<leader>d', ':lua CloseHelpOrTmpWindow()<CR>')
vim.keymap.set('n', '<leader>sf', ':Pick files')
vim.keymap.set('n', '<leader>sg', ':Pick grep')

-- Language server specific bindings
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)



require("mason").setup()
require("mini.pick").setup()


-- Configure lua's langauge server, mostly for editing vim configs
vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    settings = {
        Lua = {}
    }
})

vim.lsp.enable({ "lua_ls", "rust_analyzer", "rustfmt" })
