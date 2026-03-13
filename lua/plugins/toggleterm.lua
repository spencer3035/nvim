-- Plugin to handle terminals
vim.pack.add({ 'https://github.com/akinsho/toggleterm.nvim' })
require("toggleterm").setup({
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            -- half of avaliable screen
            return vim.o.columns * 0.5
        end
    end,
    close_on_exit = true,
    auto_scroll = true,
    shade_terminals = true,
})
