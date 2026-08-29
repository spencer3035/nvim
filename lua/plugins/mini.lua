-- For the Pick function
local fn = require('fn')

vim.pack.add({
    { src = fn.maybe_local_plugin('https://github.com/echasnovski/mini.pick') },
})
-- For fuzzy finder
require("mini.pick").setup()

--------------------------------------------
--------------- Bindings -------------------
--------------------------------------------
local opts = { noremap = true, silent = true }
-- Search files
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>', opts)
-- Search by grep
vim.keymap.set('n', '<leader>sg', ':Pick grep<CR>', opts)
