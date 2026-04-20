vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        java = { "spotless_maven" },
        sql = { "sqruff" },
        json = { "fixjson" },
    },
})

local set = vim.keymap.set;
local opts = { noremap = true, silent = true }
set({ 'n', 'v' }, '<leader>lf', conform.format, opts)
