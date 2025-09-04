-- AUTOCOMMANDS
-- Definitions for all my autocmds

-- Put help text to right side instead of top
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = { "help" }, command = "wincmd L", }
)

-- Which filetypes to automatically format
vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        pattern = { "*.rs", "*.lua" },
        callback = function() vim.lsp.buf.format({ async = false }) end
    }
)

-- Remember last position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        local ignored_file = (vim.bo.filetype == 'gitcommit')

        if mark[1] > 0 and mark[1] <= lcount and not ignored_file then
            pcall(vim.api.nvim_win_set_cursor, 0, { mark[1], mark[2] })
        end
    end,
})

-- Don't set the format expressions so that gq motions can format comments
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "*",
        callback = function()
            vim.bo.formatexpr = " "
            vim.bo.formatprg = " "
        end
    }
)
