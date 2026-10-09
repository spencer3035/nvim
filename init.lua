-- My neovim configs

-- TODO:
-- - Force quit programs running in toggleterm. Possibly experiment with
--   Terminal:shutdown()? Not sure how to get the correct terminal instance
-- - Setup a git plugin to do all the git stuff

vim.g.work_config_enabled = vim.env.NVIM_WORK_CONFIG == '1'

-- Keep work-specific configuration separate from the shared configuration.
-- Enable it with: NVIM_WORK_CONFIG=1 nvim
if vim.g.work_config_enabled then
    require('work');
end

require('settings');
require('bindings');
require('plugins');
require('lsp');
require('auto_commands');
