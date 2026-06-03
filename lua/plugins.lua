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

-- Sets colorscheme
vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
})
vim.cmd('colorscheme tokyonight')
