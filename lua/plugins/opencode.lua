vim.pack.add({
    {
        src = "https://github.com/nickjvandyke/opencode.nvim",
        version = vim.version.range("*"), -- Latest stable release
    },
})

vim.keymap.set({ "n", "x" }, "<leader>ao", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode…" })
-- vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "Select OpenCode…" })

vim.keymap.set("n", "ag", function() require("opencode").command("session.last") end,
    { desc = "Scroll OpenCode up" })
