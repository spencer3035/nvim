-- Installs plugins and configures them

require("plugins/nvim-treesitter")
require("plugins/claudecode")
require("plugins/conform")
require("plugins/blink")
require("plugins/oil")
require("plugins/toggleterm")
require("plugins/luasnip")
require("plugins/neogit")
require("plugins/mini")

-- Sets colorscheme
vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
})
vim.cmd('colorscheme tokyonight')
