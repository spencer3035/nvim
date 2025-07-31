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
    { src = 'https://github.com/akinsho/toggleterm.nvim' },
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

-- BINDINGS
vim.keymap.set('n', '<leader>so', ':update<CR>:so ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>q', ':q')
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>')
vim.keymap.set('n', '<leader>sg', ':Pick grep<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.keymap.set('i', '\'', '\'\'<left>');
vim.keymap.set('i', '"', '""<left>');
vim.keymap.set('i', '(', '()<left>');
vim.keymap.set('i', '{', '{}<left>');
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O');

vim.keymap.set('n', '<leader>t', ':lua TermTest()<CR>')
vim.keymap.set('n', '<leader>f', ':lua TermRun()<CR>')
vim.keymap.set('n', '<leader>d', ':ToggleTerm<CR>')

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

local function debug_function()
    print("You found my debug function! Nothing do see here")
end

local function runNewTerminalCommand(cmd)
    vim.cmd("TermExec direction=vertical cmd=clear")
    vim.cmd("TermExec direction=vertical cmd=\"" .. cmd .. "\"")
end

--- Get the command to run for an arbitrary file open in the current buffer
--- @param isTest boolean If should return test command or run command
--- @return string? Command to run or nil if couldn't be determined
local function getProjectCommand(isTest)
    local ft = vim.api.nvim_get_option_value("filetype", {});
    -- Full file name
    local file_name = vim.fn.expand('%:p');
    local base_name = vim.fs.basename(file_name);
    if base_name == "Cargo.toml" then
        if isTest then
            return "cargo test"
        else
            return "cargo run"
        end
    end
    if base_name == "Makefile" then
        if isTest then
            return "make test"
        else
            return "make run"
        end
    end
    if ft == "rust" then
        if isTest then
            return "cargo test"
        else
            return "cargo run"
        end
    end

    -- Could be nil
    local git_dir = vim.fs.root(0, '.git')
    -- Traverse files around the git dir to get hints on what to run
    if git_dir then
        local base_dir_name = vim.fs.basename(git_dir)
        if base_dir_name == "nvim" then
            debug_function()
            return nil
        end
        for entry in vim.fs.dir(git_dir) do
            if entry == "Cargo.toml" then
                if isTest then
                    return "cargo test"
                else
                    return "cargo run"
                end
            end
            if entry == "Makefile" then
                if isTest then
                    return "make test"
                else
                    return "make run"
                end
            end
        end
    end
    return nil
end

function TermRun()
    local cmd = getProjectCommand(false);
    if cmd ~= nil then
        runNewTerminalCommand(cmd)
    end
end

function TermTest()
    local cmd = getProjectCommand(true);
    if cmd ~= nil then
        runNewTerminalCommand(cmd)
    end
end

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
