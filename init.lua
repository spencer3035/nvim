-- My neovim configs

-- TODO:
-- - Force quit programs running in toggleterm. Possibly experiment with
--   Terminal:shutdown()? Not sure how to get the correct terminal instance
-- - Setup a git plugin to do all the git stuff

require('settings');
require('bindings');
require('plugins');
require('lsp');
require('auto_commands');
