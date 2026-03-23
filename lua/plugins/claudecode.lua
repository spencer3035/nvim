vim.pack.add({
    { src = 'https://github.com/coder/claudecode.nvim' },
    -- { src = 'https://github.com/folke/snacks.nvim' }, -- dependency of claudecode
})
require("claudecode").setup({
    auto_start = true,
    terminal = {
        split_side = "right",
    },
    git_repo_cwd = true,
})
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>")
vim.keymap.set("n", "<leader>al", "<cmd>ClaudeCodeFocus<cr>")
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>")
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>")
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>")
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeAdd %<cr>")
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>")
-- Diff management
vim.keymap.set("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>")
vim.keymap.set("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>")
