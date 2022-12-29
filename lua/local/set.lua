vim.opt.compatible = false

-- Convenience settings
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.autoindent = true

-- Tab = 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

vim.opt.smartindent = true;

-- Number settings
vim.opt.number = true
vim.opt.relativenumber = true

-- Bash-like tab completion
vim.opt.wildmode = 'longest,list'

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.g.mapleader = " "

-- Primagen mappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move highlighted chunks around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste text over existing text without changing active register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete without changing active register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Format current file
vim.keymap.set("n", "<leader>q", vim.lsp.buf.format)

-- TODO use lsp find and replace
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
