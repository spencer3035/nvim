vim.g.mapleader = ' '

-- Spacing
vim.opt.shiftwidth = 4;
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

vim.api.nvim_create_autocmd(

    {
        "FileType"
    },
    {
        pattern  = { "*.rs" },
        command = "wincmd L",
    }
)

-- BINDINGS
-- Shortcuts for common stuff
vim.keymap.set('n', '<leader>so', ':update<CR>:so ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>q', ':q ')
-- Language server specific bindings
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

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


require("mason").setup()


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

vim.lsp.enable({ "lua_ls", "rust_analyzer" })
