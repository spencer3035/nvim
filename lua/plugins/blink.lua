vim.pack.add({ { src = 'https://github.com/saghen/blink.cmp', version = "v1" } })

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
    sources = {
        providers = {
            path = {
                opts = {
                    -- Use cwd instead of current file dir for paths
                    get_cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                },
            },
        },
    },
    fuzzy = { implementation = "lua" },
    keymap = { preset = 'default' },
})
