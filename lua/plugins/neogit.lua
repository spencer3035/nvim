-- Neogit (git integration)
vim.pack.add({
    { src = 'https://github.com/NeogitOrg/neogit' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },  -- Dependency of neogit
    { src = 'https://github.com/sindrets/diffview.nvim' }, -- Diff integration (dependency of neogit)
})
require('neogit').setup({})

-- Bindings

local set = vim.keymap.set;
local opts = { noremap = true, silent = true }
set('n', '<leader>g', ':Neogit<CR>', opts)
