-- Neogit (git integration)

local fn = require('fn')

vim.pack.add({
    { src = fn.maybe_local_plugin('https://github.com/NeogitOrg/neogit') },
    { src = fn.maybe_local_plugin('https://github.com/nvim-lua/plenary.nvim') },  -- Dependency of neogit
    { src = fn.maybe_local_plugin('https://github.com/sindrets/diffview.nvim') }, -- Diff integration (dependency of neogit)
})
require('neogit').setup({})

-- Bindings

local set = vim.keymap.set;
local opts = { noremap = true, silent = true }
set('n', '<leader>g', ':Neogit<CR>', opts)
