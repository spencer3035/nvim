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

-- visuals
vim.opt.winborder = "rounded"

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
    -- For better syntax highlighting
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    -- Colorscheme
    { src = "https://github.com/folke/tokyonight.nvim" },
})

-- Remember last position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if
            mark[1] > 0 and
            mark[1] <= lcount and
            not (vim.bo.filetype == 'gitcommit')
        then
            pcall(vim.api.nvim_win_set_cursor, 0, { mark[1], mark[2] })
        end
    end,
})


-- Put help text to right side instead of top
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = { "help" }, command = "wincmd L", }
)

-- Which filetypes to automatically format
vim.api.nvim_create_autocmd(
    "BufWritePre",
    { pattern = { "*.rs", "*.lua" }, callback = function() vim.lsp.buf.format({ async = false }) end }
)

-- BINDINGS
-- source init.lua
vim.keymap.set('n', '<leader>so', ':update<CR>:so ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua<CR>')
-- Edit init.lua (config edit)
vim.keymap.set('n', '<leader>ce', ':tabnew ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua<CR>')
-- Quicker way to quit
vim.keymap.set('n', '<leader>q', ':q')
-- Search files
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>')
-- Search by grep
vim.keymap.set('n', '<leader>sg', ':Pick grep<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', [["+y]], { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', [["+p]], { noremap = true, silent = true })

-- vim.keymap.set('i', '\'\'', '\'\'<left>');
-- vim.keymap.set('i', '""', '""<left>');
-- vim.keymap.set('i', '((', '()<left>');
-- vim.keymap.set('i', '{{', '{}<left>');
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O');
vim.keymap.set('i', '(<CR>', '(<CR>)<ESC>O');

vim.keymap.set('n', '<leader>t', ':lua TermTest()<CR>')
vim.keymap.set('n', '<leader>f', ':lua TermRun()<CR>')
vim.keymap.set('n', '<leader>d', ':ToggleTerm<CR>')

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- digraphs
vim.cmd('digraphs f, ' .. vim.fn.char2nr("，"))
vim.cmd('digraphs f: ' .. vim.fn.char2nr("："))
vim.cmd('digraphs f? ' .. vim.fn.char2nr("？"))

local function capture_output(cmd)
    -- Capture output of any command as a string
    local output = vim.fn.execute(cmd)
    local lines = vim.split(output, "\n", { plain = true })

    -- Open a new scratch buffer in a split
    vim.cmd("botright new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    -- Make it a clean scratch buffer
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.filetype = "output"
    vim.wo.wrap = false
    vim.wo.number = false
end

-- Create the user command :CaptureOutput {cmd}
--
-- This takes the output of the command and puts it in a scratch buffer instead of the internal pager.
vim.api.nvim_create_user_command("CaptureOutput", function(opts)
    capture_output(opts.args)
end, {
    nargs = "+",         -- Require at least one arg (the command)
    complete = "command" -- Allow tab-completion of commands
})

local function debug_function()
    print("You found my debug function! Nothing do see here")
end

local function run_new_terminal_command(cmd)
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
        run_new_terminal_command(cmd)
    end
end

function TermTest()
    local cmd = getProjectCommand(true);
    if cmd ~= nil then
        run_new_terminal_command(cmd)
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

-- Configure plugins
vim.cmd('colorscheme tokyonight')

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
require("mini.pick").setup()

-- Configure lua's langauge server, mostly for editing vim configs
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
})

vim.lsp.config("rnix-lsp", {})

vim.lsp.enable({
    "lua_ls",
    "rust_analyzer",
    "rnix"
})
