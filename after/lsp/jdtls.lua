---@type vim.lsp.Config
local config = {
    ---@type lspconfig.settings.jdtls
    settings = {
        java = {
            compile = {
                nullAnalysis = {
                    mode = "automatic",
                }
            }
        }
    }

}

return config
