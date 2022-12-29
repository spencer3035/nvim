vim.keymap.set("n","<Leader>e",vim.cmd.Ex)

-- Navigave buffers with <Ctrl-J> and <Ctrl-K>
-- Note that <C-J> gets messed up by /usr/share/vim/vimfiles/plugin/imaps.vim.
-- it is recommended to remove (or backup) that file if this binding isn't
-- working. 
vim.keymap.set('n','<C-J>', ':bn<CR>')
vim.keymap.set('n','<C-K>', ':bp<CR>')
vim.keymap.set('n','<ESC>', ':noh<CR><ESC>')

-- Compile and run code in split window. The run_code function is in
-- ftconfig.lua
vim.keymap.set('n', '<Leader>s',':lua run_code(true)<CR>')
-- Test code
vim.keymap.set('n', '<Leader>t',':lua test_code(false)<CR>')
-- Close window and run code
vim.keymap.set('n', '<Leader>f',':lua run_code(false)<CR>')

-- Delete bottom right window. Useful for the above
vim.keymap.set('n', '<Leader>d',':wincmd b | bd | wincmd p <CR>')

-- Find and replace
vim.keymap.set('n','<Leader>r', [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]])

-- For marking files important
vim.keymap.set('n', '<Leader>m1',':lua mark_file_important(1) <CR>')
vim.keymap.set('n', '<Leader>m2',':lua mark_file_important(2) <CR>')
vim.keymap.set('n', '<Leader>m3',':lua mark_file_important(3) <CR>')
vim.keymap.set('n', '<Leader>m4',':lua mark_file_important(4) <CR>')

vim.keymap.set('n', '<Leader>1',':lua open_important_file(1) <CR>')
vim.keymap.set('n', '<Leader>2',':lua open_important_file(2) <CR>')
vim.keymap.set('n', '<Leader>3',':lua open_important_file(3) <CR>')
vim.keymap.set('n', '<Leader>4',':lua open_important_file(4) <CR>')

vim.keymap.set('n', '<Leader>q1',':lua delete_important_file(1) <CR>')
vim.keymap.set('n', '<Leader>q2',':lua delete_important_file(2) <CR>')
vim.keymap.set('n', '<Leader>q3',':lua delete_important_file(3) <CR>')
vim.keymap.set('n', '<Leader>q4',':lua delete_important_file(4) <CR>')
