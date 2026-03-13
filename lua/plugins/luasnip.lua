-- Snippet engine
vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" })
local ls = require('luasnip')
ls.setup({ enable_autosnippets = true })
require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets" })

-- Bindings

local opts = { noremap = true, silent = true }
local set = vim.keymap.set;

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
