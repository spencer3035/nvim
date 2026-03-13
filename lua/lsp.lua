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
-- Note that their configs are in nvim/lsp/*
-- Go there if you want to make changes to them
vim.lsp.enable({
    "jsonls",
    "lua_ls",
    "rust_analyzer",
    "rnix",
    "slint-lsp",
    "gopls",
    "yamlls",
    "gitlab-ci-ls",
})
