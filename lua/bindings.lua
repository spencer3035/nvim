local fn = require('fn')
local set = vim.keymap.set;
local opts = { noremap = true, silent = true }

--------------------------------------------
------------- INSERT MODE ------------------
--------------------------------------------

set('i', '{<CR>', '{<CR>}<ESC>O');
set('i', '(<CR>', '(<CR>)<ESC>O');
-- Quicker way to quit
set('i', '<C-q>', '<ESC>:q<CR>', opts)

--------------------------------------------
------------- NORMAL MODE ------------------
--------------------------------------------

-- source init.lua
set('n', '<leader>o', fn.reload_config, opts)
-- -- debug function don't captures
set('n', '<leader>?', function()
    fn.debug_function()
end, opts)
-- Edit init.lua (config edit)
set('n', '<leader>ce', ':tabnew ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua | tcd %:p:h<CR>', opts)
-- Quicker way to quit
set('n', '<leader>q', ':tabclose<CR>', opts)
set('n', '<C-q>', ':q<CR>', opts)
-- Quicker way to save and quit
set('n', '<leader>x', ':x<CR>', opts)
-- Quicker way to save
set('n', '<leader>w', ':w<CR>', opts)

-- LSP functions
set({ 'n', 'v' }, '<leader>lf', vim.lsp.buf.format, opts)
set('n', '<leader>ld', vim.lsp.buf.definition, opts)
set({ 'n', 'v', 'x' }, '<leader>la', vim.lsp.buf.code_action, opts)
set('n', '<leader>lr', vim.lsp.buf.references, opts)

set({ 'n', 'v', 'x' }, '<leader>yf', function() vim.fn.setreg('"', vim.fn.expand('%:p')) end, opts)
set({ 'n', 'v', 'x' }, '<leader>p', [["+p]], opts)

-- Convert url to markdown link with text set to final path in url
set('n', '<leader>ml', 'viWc[](<ESC>pa)<ESC>T/yt)F]PF[', opts)

set('n', '<leader>bu', function()
    fn.import_java_fqdn()
end, opts)

-- Quick way to change dir
set('n', '<leader>cd', function()
    local dir = fn.get_git_or_file_dir()
    if dir then
        vim.cmd("lcd " .. dir)
    else
        print("Error: Not in a git repository and no file in current buffer")
    end
end, opts)

--------------------------------------------
------------ TERMINAL MODE -----------------
--------------------------------------------

-- Make <Esc> return to normal mode when in terminal mode
-- set('t', '<Esc>', '<C-\\><C-n>')
-- Map the default terminal escape sequence to send an escape character
-- set('t', '<C-\\><C-n>', '<Esc>')

--------------------------------------------
------------- VISUAL MODE ------------------
--------------------------------------------

-- Has the effect of putting highlighted section in a block on the next line ({...})
set('v', '<leader>{', 'c{<CR><C-r>"<CR>}<ESC>%', opts)

-- Don't pass stuff that will mess with insert mode
local function get_visual_surround_macro(start_str, end_str)
    return
    -- Exit visual, jump to end of selection, enter insert mode
        '<ESC>`>a' ..
        -- Enter string
        end_str ..
        -- Exit insert mode, jump to end of selection, enter insert mode
        '<ESC>`<i' ..
        -- Enter string
        start_str ..
        -- Enter normal mode, nav to end (assuming only one character was entered)
        '<ESC>`>l'
end
-- surround with brackets
set('v', '<leader>[', get_visual_surround_macro('[', ']'), opts)
-- surround with parens
set('v', '<leader>(', get_visual_surround_macro('(', ')'), opts)
-- surround with "
set('v', '<leader>"', get_visual_surround_macro('"', '"'), opts)
-- surround with '
set('v', '<leader>\'', get_visual_surround_macro('\'', '\''), opts)

--------------------------------------------
--------------- DIGRAPHS -------------------
--------------------------------------------
-- fullwidth comma
vim.cmd('digraphs f, ' .. vim.fn.char2nr("，"))
-- fullwidth colon
vim.cmd('digraphs f: ' .. vim.fn.char2nr("："))
-- fullwidth question mark
vim.cmd('digraphs f? ' .. vim.fn.char2nr("？"))

--------------------------------------------
------------- USER COMMANDS ----------------
--------------------------------------------
