local fn = require('fn')
local set = vim.keymap.set;
local opts = { noremap = true, silent = true }

--------------------------------------------
------------- INSERT MODE ------------------
--------------------------------------------

set('i', '{<CR>', '{<CR>}<ESC>O');
set('i', '(<CR>', '(<CR>)<ESC>O');

--------------------------------------------
------------- NORMAL MODE ------------------
--------------------------------------------

-- source init.lua
set('n', '<leader>o', fn.reload_config, opts)
-- debug function don't captures
set('n', '<leader>dd', function()
    fn.debug_function()
end, opts)
-- debug function (capture output)
set('n', '<leader>dc', function()
    -- fn.reload_config()
    -- fn.debug_function()
    fn.capture_output("lua require(\"fn\").debug_function()")
end, opts)
-- Edit init.lua (config edit)
set('n', '<leader>c', ':tabnew ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua | tcd %:p:h<CR>', opts)
-- Quicker way to quit
set('n', '<leader>q', ':tabclose<CR>', opts)

-- LSP functions
-- set({ 'n', 'v' }, '<leader>lf', vim.lsp.buf.format, opts)
set('n', '<leader>ld', vim.lsp.buf.definition, opts)
set({ 'n', 'v', 'x' }, '<leader>la', vim.lsp.buf.code_action, opts)
set('n', '<leader>lr', vim.lsp.buf.references, opts)

set({ 'n', 'v', 'x' }, '<leader>y', [["+y]], opts)
set({ 'n', 'v', 'x' }, '<leader>p', [["+p]], opts)

set('n', '<leader>tt', fn.TermTest, opts)
set('n', '<leader>tr', fn.TermRun, opts)
set('n', '<leader>to', ':ToggleTerm direction=vertical<CR>', opts)

set('n', '<leader>>', fn.swap_arg_forward, opts)
set('n', '<leader><lt>', fn.swap_arg_back, opts)

-- Convert url to markdown link with text set to final path in url
set('n', '<leader>ml', 'viWc[](<ESC>pa)<ESC>T/yt)F]PF[', opts)

--------------------------------------------
------------ TERMINAL MODE -----------------
--------------------------------------------

-- Make <Esc> return to normal mode when in terminal mode
set('t', '<Esc>', '<C-\\><C-n>')
-- Map the default terminal escape sequence to send an escape character
set('t', '<C-\\><C-n>', '<Esc>')
set('t', 'kj', '<C-\\><C-n>', { silent = true, desc = "Exit insert mode" })

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

-- Create the user command :CaptureOutput {cmd}
--
-- This takes the output of the command and puts it in a scratch buffer instead of the internal pager.
vim.api.nvim_create_user_command("CaptureOutput", function(opt)
    fn.capture_output(opt.args)
end, {
    nargs = "+",         -- Require at least one arg (the command)
    complete = "command" -- Allow tab-completion of commands
})
