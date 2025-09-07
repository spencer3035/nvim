-- My neovim configs

-- TODO:
-- - Force quit programs running in toggleterm. Possibly experiment with
--   Terminal:shutdown()? Not sure how to get the correct terminal instance
-- - Setup a git plugin to do all the git stuff

require('plugins');
require('settings');
require('bindings');
require('auto_commands');
