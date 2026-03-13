-- File manager that doesn't suck (netrw)
vim.pack.add({ 'https://github.com/stevearc/oil.nvim' })
require("oil").setup({
    keymaps = {
        ["<C-p>"] = { "actions.preview", opts = { split = "botright" } }
    },
    skip_confirm_for_simple_edits = true,
    natural_order = true,
    float = {
        preview_split = "right",
    },
    preview_win = {
        preview_split = "right",
    }
})
