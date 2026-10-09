-- Installs plugins and configures them

-- Setup before others because it is a dependency
require("plugins/snacks")

require("plugins/arborist-ts")
require("plugins/blink")
require("plugins/dap")
require("plugins/luasnip")
require("plugins/mini")
require("plugins/neogit")
require("plugins/opencode")
require("plugins/oil")

-- Sets colorscheme
local fn = require('fn')

vim.pack.add({
    { src = fn.maybe_local_plugin("https://github.com/folke/tokyonight.nvim") },
})
require('tokyonight').setup(
    {
        style = "night",
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            variables = { italic = true },
        }
    }
)
vim.cmd('colorscheme tokyonight')
