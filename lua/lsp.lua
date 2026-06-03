vim.pack.add({
    -- For java
    { src = 'https://github.com/mfussenegger/nvim-jdtls' },
    -- For installing LSP servers automatically
    { src = 'https://github.com/mason-org/mason.nvim' },
    -- For automatic LSP configuration
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

require("mason").setup()

-- Enable desired LSPs
-- Note that their base configs are provided by nvim-lspconfig and overrides are in ~/.config/nvim/after/lsp/*
vim.lsp.enable({
    "jsonls",
    "lua_ls",
    "rust_analyzer",
    "rnix",
    "slint-lsp",
    "gopls",
    "yamlls",
    "gitlab-ci-ls",
    "bashls",
    "pylsp",
    -- Doesn't work as well
    -- "kotlin_lsp",
    "kotlin_language_server",
    "jdtls",
})
