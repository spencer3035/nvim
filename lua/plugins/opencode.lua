local snacks = require("snacks")

local function send_to_opencode(prompt)
    local current_win = vim.api.nvim_get_current_win()
    local term = snacks.terminal.get("opencode", { create = true })

    if not term then
        return
    end

    if not term.win or not vim.api.nvim_win_is_valid(term.win) then
        term:show()
    end

    local chan_id = vim.bo[term.buf].channel
    if chan_id then
        vim.fn.chansend(chan_id, prompt .. "\n")
    end

    if vim.api.nvim_win_is_valid(current_win) then
        vim.api.nvim_set_current_win(current_win)
    end
    vim.cmd("stopinsert")
end

local function current_file()
    local path = vim.fn.expand("%:p")
    if path == "" then
        vim.notify("OpenCode context requires a named file", vim.log.levels.WARN)
        return nil
    end
    return path
end

local function send_file()
    local path = current_file()
    if path then
        send_to_opencode(path)
    end
end

local function send_visual_selection()
    local path = current_file()
    if not path then
        return
    end

    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)
    vim.schedule(function()
        send_to_opencode(("%s:%d-%d"):format(path, start_line, end_line))
    end)
end

vim.keymap.set("n", "<leader>ao", function()
    local term = snacks.terminal.get("opencode", { create = true })
    if term and (not term.win or not vim.api.nvim_win_is_valid(term.win) or term.win ~= vim.api.nvim_get_current_win()) then
        term:show()
    end
end, { desc = "Toggle OpenCode" })
vim.keymap.set("n", "<leader>af", send_file, { desc = "Send file to OpenCode" })
vim.keymap.set("v", "<leader>as", send_visual_selection, { desc = "Send selection to OpenCode" })
