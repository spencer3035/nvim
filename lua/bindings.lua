local fn = require('fn')

-- source init.lua
vim.keymap.set('n', '<leader>s', fn.reload_config)
-- debug function
vim.keymap.set('n', '<leader><leader>s', function()
    fn.reload_config()
    fn.debug_function()
end)
-- Edit init.lua (config edit)
vim.keymap.set('n', '<leader>c', ':tabnew ' .. vim.fn.expand('~') .. '/.config/nvim/init.lua | tcd %:p:h<CR>')
-- Quicker way to quit
vim.keymap.set('n', '<leader>q', ':q')
vim.keymap.set('i', '<C-j>', "<C-x><C-o>");

-- Search
-- Search files
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>')
-- Search by grep
vim.keymap.set('n', '<leader>sg', ':Pick grep<CR>')

-- LSP functions
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition)
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>la', vim.lsp.buf.code_action)

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', [["+y]], { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', [["+p]], { noremap = true, silent = true })

vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O');
vim.keymap.set('i', '(<CR>', '(<CR>)<ESC>O');

vim.keymap.set('n', '<leader>tl', fn.TermTest)
vim.keymap.set('n', '<leader>tk', fn.TermRun)
vim.keymap.set('n', '<leader>tj', ':ToggleTerm<CR>')

-- Make <Esc> return to normal mode when in terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- digraphs
vim.cmd('digraphs f, ' .. vim.fn.char2nr("，"))
vim.cmd('digraphs f: ' .. vim.fn.char2nr("："))
vim.cmd('digraphs f? ' .. vim.fn.char2nr("？"))

-- local ls = require('luasnip');
-- vim.keymap.set('i', "<C-l>", function() ls.expand() end, { silent = true })
-- vim.keymap.set('i', "<C-j>", function() ls.jump(1) end, { silent = true })
-- TODO: This doesn't seem to work
-- vim.keymap.set('i', "<C-k>", function() ls.jump(-1) end, { silent = true })

-- User commands

-- Create the user command :CaptureOutput {cmd}
--
-- This takes the output of the command and puts it in a scratch buffer instead of the internal pager.
vim.api.nvim_create_user_command("CaptureOutput", function(opts)
    fn.capture_output(opts.args)
end, {
    nargs = "+",         -- Require at least one arg (the command)
    complete = "command" -- Allow tab-completion of commands
})
