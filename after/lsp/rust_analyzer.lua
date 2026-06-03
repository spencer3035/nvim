---@type vim.lsp.Config
local config = {
    ---@type lspconfig.settings.rust_analyzer
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy"
            }
        }
    }

}

return config
