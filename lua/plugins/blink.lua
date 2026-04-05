vim.pack.add({ 'https://github.com/Saghen/blink.cmp' })

require('blink.cmp').setup({
    cmdline = {
        enabled = true,
        keymap = {
            preset = 'cmdline',
            ['<Tab>'] = { 'select_and_accept' },
        },
        completion = { menu = { auto_show = true } },
    },
    completion = {
        accept = { auto_brackets = { enabled = true }, },
        menu = { auto_show = true },
        ghost_text = {
            enabled = true,
            show_with_menu = true,
        },
    },
    fuzzy = { implementation = "lua" },
    keymap = { preset = 'default' },
})
