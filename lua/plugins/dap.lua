vim.pack.add({ 'https://github.com/mfussenegger/nvim-dap' })

local dap = require('dap');

vim.keymap.set('n', '<leader>dc', function() dap.continue() end)
vim.keymap.set('n', '<leader>ds', function() dap.step_over() end)
vim.keymap.set('n', '<leader>di', function() dap.step_into() end)
vim.keymap.set('n', '<leader>do', function() dap.step_out() end)
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint() end)
-- vim.keymap.set('n', '<leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
-- vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end)
-- vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
-- vim.keymap.set('n', '<leader>d', function()
--     local widgets = require('dap.ui.widgets')
--     widgets.centered_float(widgets.scopes)
-- end)

-- Java Debug Adapter configuration
-- For remote debugging, we use a simple server adapter that connects to the JVM's debug port
dap.adapters.java = function(callback)
    callback({
        type = 'server',
        host = '127.0.0.1',
        port = 8001,
    })
end

-- Java Debug Configurations
dap.configurations.java = {
    {
        type = 'java',
        request = 'attach',
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 8001,
    },
}
