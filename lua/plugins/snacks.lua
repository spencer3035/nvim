local fn = require('fn')

vim.pack.add({
    { src = fn.maybe_local_plugin('https://github.com/folke/snacks.nvim') },
})

require('snacks').setup(
    {
        terminal = {
            enabled = true,
            auto_insert = false, -- Don't automatically enter insert mode when switching to terminal
            win = {
                position = "right",
                keys = {
                    term_normal = false, -- Disable the double-escape timer behavior
                    ["<esc>"] = {
                        function(self)
                            vim.cmd("stopinsert")
                        end,
                        mode = "t",
                        desc = "Escape to normal mode",
                    },
                    ["<C-q>"] = {
                        function(self)
                            self:hide()
                        end,
                        mode = "t",
                        desc = "Toggle terminal off",
                    },
                }
            }
        }
    }
)

local snacks = require("snacks")
local fn = require("fn")

-- Terminal functions
local function send_to_terminal(cmd)
    local current_win = vim.api.nvim_get_current_win()

    if cmd == nil then return end
    local term = snacks.terminal.get(nil, { create = true })
    if not term then return end


    if not term.win or not vim.api.nvim_win_is_valid(term.win) then
        term:show()
    end
    local chan_id = vim.bo[term.buf].channel


    if chan_id then
        vim.fn.chansend(chan_id, cmd .. "\n")
    end

    vim.api.nvim_set_current_win(current_win)
    vim.cmd("stopinsert")
end



local function run_command()
    send_to_terminal(fn.TermRunCmd())
end

local function test_command()
    send_to_terminal(fn.TermTestCmd())
end

local function show_terminal()
    -- Save current window before showing terminal
    local current_win = vim.api.nvim_get_current_win()

    local term = snacks.terminal.get(nil, { create = true })
    if not term then return end

    if not term.win or not vim.api.nvim_win_is_valid(term.win) then
        term:show()
    end

    -- Restore focus to original window and stay in normal mode
    vim.api.nvim_set_current_win(current_win)
    vim.cmd("stopinsert")
end

-- Terminal keybindings
vim.keymap.set("n", "<leader>to", snacks.terminal.toggle, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>ts", show_terminal, { desc = "Send command to terminal" })
vim.keymap.set("n", "<leader>tr", run_command, { desc = "Send command to terminal" })
vim.keymap.set("n", "<leader>tt", test_command, { desc = "Send command to terminal" })
