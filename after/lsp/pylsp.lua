---@type vim.lsp.Config
local config = {
    ---@type lspconfig.settings.pylsp
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'W391' },
                    maxLineLength = 100
                }
            }
        }
    }
}

return config
