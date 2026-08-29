local fn = require('fn')

vim.pack.add({
    { src = fn.maybe_local_plugin("https://github.com/arborist-ts/arborist.nvim") },
})
require("arborist").setup()
