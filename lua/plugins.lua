-- Installs plugins and configures them

require("plugins/arborist-ts")
require("plugins/blink")
require("plugins/claudecode")
require("plugins/dap")
require("plugins/luasnip")
require("plugins/mini")
require("plugins/neogit")
require("plugins/oil")
require("plugins/toggleterm")
-- require("plugins/mustache-support").setup()

-- Sets colorscheme
vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
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
