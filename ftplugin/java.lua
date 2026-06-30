vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.expandtab = true

vim.keymap.set('n', '<leader>lf', function()
    local file = vim.api.nvim_buf_get_name(0)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.fn.system('google-java-format --replace "' .. file .. '"')
    vim.cmd('edit!')
    vim.api.nvim_win_set_cursor(0, cursor_pos)
end, { buffer = true, desc = 'Format Java with google-java-format' })
