local fn = require('fn')
local set = vim.keymap.set;
local opts = { noremap = true, silent = true }

--------------------------------------------
------------- INSERT MODE ------------------
--------------------------------------------

set('i', '{<CR>', '{<CR>}<ESC>O');
set('i', '(<CR>', '(<CR>)<ESC>O');
set('i', '<C-j>', "<C-x><C-o>");

local ls = require('luasnip');
set('i', "<C-h>", function() ls.jump(-1) end, opts)
set('i', "<C-l>", function() ls.jump(1) end, opts)
set('i', "<C-e>", function()
    local snip = ls.get_active_snip()
    if snip ~= nil then
        ls.unlink_current()
    else
        return '<C-e>'
    end
end, { silent = true, expr = true })
set('i', "<C-p>", function()
    if ls.choice_active() then
        ls.change_choice(-1)
    else
        -- We have to do this nonsense to fallback to default behavior
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', false)
    end
end, opts)
set('i', "<C-n>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    else
        -- We have to do this nonsense to fallback to default behavior
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', false)
    end
end, opts)

--------------------------------------------
------------- NORMAL MODE ------------------
--------------------------------------------
-- git commands
set('n', '<leader>g', ':Neogit<CR>', opts)

-- source init.lua
set('n', '<leader>s', fn.reload_config, opts)
-- debug function
set('n', '<leader><leader>s', function()
    fn.reload_config()
    fn.debug_function()
end, opts)
-- Edit init.lua (config edit)
set('n', '<leader>c', ':tabnew ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua | tcd %:p:h<CR>', opts)
-- Quicker way to quit
set('n', '<leader>q', ':q<CR>', opts)

-- Search
-- Search files
set('n', '<leader>sf', ':Pick files<CR>', opts)
-- Search by grep
set('n', '<leader>sg', ':Pick grep<CR>', opts)

-- LSP functions
set('n', '<leader>lf', vim.lsp.buf.format, opts)
set('n', '<leader>ld', vim.lsp.buf.definition, opts)
set({ 'n', 'v', 'x' }, '<leader>la', vim.lsp.buf.code_action, opts)
set('n', '<leader>lr', vim.lsp.buf.references, opts)

set({ 'n', 'v', 'x' }, '<leader>y', [["+y]], opts)
set({ 'n', 'v', 'x' }, '<leader>p', [["+p]], opts)

set('n', '<leader>tl', fn.TermTest, opts)
set('n', '<leader>tk', fn.TermRun, opts)
set('n', '<leader>tj', ':ToggleTerm direction=vertical<CR>', opts)

--------------------------------------------
------------ TERMINAL MODE -----------------
--------------------------------------------

-- Make <Esc> return to normal mode when in terminal mode
set('t', '<Esc>', '<C-\\><C-n>')

--------------------------------------------
------------- VISUAL MODE ------------------
--------------------------------------------

-- Has the effect of putting highlighted section in a block on the next line ({...})
set('v', '<leader>{', 'c{<CR>}<ESC>O<C-r>"<ESC>O', opts)

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
