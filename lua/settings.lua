-- SETTINGS
-- These are for configuration of the vim variables.

-- General

vim.g.mapleader = ' '

-- Spacing

vim.opt.shiftwidth = 4;
vim.opt.signcolumn = "yes";
vim.opt.tabstop = 4;
vim.opt.expandtab = true;

-- Visuals

-- Tab complete behavior more similar to bash
vim.opt.wildmode = 'longest:full'
vim.opt.winborder = "rounded"
-- see :h vim.diagnostic.Opts
vim.diagnostic.config({ virtual_text = true, });

-- Line numbering
vim.opt.number = true;
vim.opt.relativenumber = true;

-- NetRw config
-- Needed to fix netrw, can be removed if I get my MR merged
vim.g.netrw_keepdir = 0;
vim.g.netrw_localcopydircmd = "cp -r"
