-- Functions
-- Helper functions to be used in bindings or other modules

local M = {}

local function ts_args()
    local ts = vim.treesitter
    local node = ts.get_node()
    if not node then return end

    -- Walk up to find an argument_list node
    while node and node:type() ~= "argument_list" do
        node = node:parent()
    end
    if not node then return end

    -- Collect argument nodes (skip punctuation like commas/parens)
    local args = {}
    for child in node:iter_children() do
        local t = child:type()
        if t ~= "," and t ~= "(" and t ~= ")" and t ~= "comment" then
            table.insert(args, child)
        end
    end

    if #args < 2 then return end

    -- Find which arg the cursor is on
    local cursor_info = vim.api.nvim_win_get_cursor(0)
    local cursor_row = cursor_info[1]
    local cursor_col = cursor_info[2]
    cursor_row = cursor_row - 1 -- 0-indexed

    local cursor_idx = nil
    for i, arg in ipairs(args) do
        local sr, sc, er, ec = arg:range()
        if cursor_row >= sr and cursor_row <= er and
            (cursor_row ~= sr or cursor_col >= sc) and
            (cursor_row ~= er or cursor_col <= ec) then
            cursor_idx = i
            break
        end
    end

    return
    {
        args = args,
        cursor_idx = cursor_idx,
    }
end

function M.swap_arg_forward()
    local info = ts_args();
    if info == nil then return end

    if not info.cursor_idx or info.cursor_idx >= #info.args then return end

    -- Swap the text of the two adjacent args
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local a, b = info.args[info.cursor_idx], info.args[info.cursor_idx + 1]

    local a_text = vim.treesitter.get_node_text(a, bufnr)
    local b_text = vim.treesitter.get_node_text(b, bufnr)

    local asr, asc, aer, aec = a:range()
    local bsr, bsc, ber, bec = b:range()

    -- Write b's text into a's position, a's text into b's position
    vim.api.nvim_buf_set_text(bufnr, bsr, bsc, ber, bec, vim.split(a_text, "\n"))
    vim.api.nvim_buf_set_text(bufnr, asr, asc, aer, aec, vim.split(b_text, "\n"))
    vim.api.nvim_win_set_cursor(winnr, { bsr + 1, bsc })
end

function M.swap_arg_back()
    local info = ts_args();
    if info == nil then return end

    if not info.cursor_idx or info.cursor_idx == 1 then return end

    -- Swap the text of the two adjacent args
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local a, b = info.args[info.cursor_idx - 1], info.args[info.cursor_idx]

    local a_text = vim.treesitter.get_node_text(a, bufnr)
    local b_text = vim.treesitter.get_node_text(b, bufnr)

    local asr, asc, aer, aec = a:range()
    local bsr, bsc, ber, bec = b:range()

    -- Write b's text into a's position, a's text into b's position
    vim.api.nvim_buf_set_text(bufnr, bsr, bsc, ber, bec, vim.split(a_text, "\n"))
    vim.api.nvim_buf_set_text(bufnr, asr, asc, aer, aec, vim.split(b_text, "\n"))
    vim.api.nvim_win_set_cursor(winnr, { asr + 1, asc })
end

function M.reload_config()
    package.loaded.plugins = nil;
    package.loaded.settings = nil;
    package.loaded.bindings = nil;
    package.loaded.auto_commands = nil;
    package.loaded.fn = nil;
    dofile(vim.fn.stdpath("config") .. "/init.lua")
end

-- Captures output of arbitraty ex command to a scratch buffer for seraching or copying from
function M.capture_output(cmd)
    -- Capture output of any command as a string
    local output = vim.fn.execute(cmd)
    local lines = vim.split(output, "\n", { plain = true })

    -- Open a new scratch buffer in a split
    vim.cmd("botright new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    -- Make it a clean scratch buffer
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.filetype = "output"
    vim.wo.wrap = false
    vim.wo.number = false
end

--- Filter avaliable code actions based on the kind provided and apply it if it gets filtered down to one.
---
--- Some helpful examples for "kind" are "add_impl_missing_members"
---
--- @param kind string Should match the title here: https://rust-analyzer.github.io/book/assists.html
local function rust_apply_quickfix(kind)
    vim.lsp.buf.code_action({
        filter = function(action)
            return action.data and action.data.id and string.match(action.data.id, kind)
        end,
        apply = true, -- automatically apply the action if only one remains
    })
end

-- Helper function to display code actions
local function display_code_action_details()
    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_range_params(0, "utf-8")
    params.context = {
        triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
        diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
    }

    vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, actions, ctx, _)
        if err then
            vim.notify("Code action error: " .. err.message, vim.log.levels.ERROR)
            return
        end
        if not actions or vim.tbl_isempty(actions) then
            vim.notify("No code actions")
            return
        end
        for _, action in pairs(actions) do
            if action.data then
                print("it is a data kind")
            end
            if action.edit then
                print("it is a edit kind")
            end
            print("kind : " .. action.kind)
            print("title : " .. action.title)
            -- print(vim.inspect(action))
        end
    end)
end

function M.debug_function()
    print("Nothing to do!")
    -- M.swap_arg_forward()
    -- M.swap_arg_back()
end

local function special_project_commands(root_dir, isTest)
    if root_dir == vim.fn.expand('~/dev/spenceros') then
        if isTest then
            return 'make test'
        else
            return 'make run'
        end
    end
end

--- Get the command to run for an arbitrary file open in the current buffer
--- @param isTest boolean If should return test command or run command
--- @return string? Command to run or nil if couldn't be determined
local function get_project_command(isTest)
    local ft = vim.api.nvim_get_option_value("filetype", {});
    -- Full file name
    local file_name = vim.fn.expand('%:p');
    local base_name = vim.fs.basename(file_name);
    -- Could be nil
    local git_dir = vim.fs.root(0, '.git')

    -- List of rules. First match is taken, so more specific rules should be earlier
    local command_rules = {
        {
            repo_path = '~/dev/spenceros',
            test_cmd = 'make test',
            run_cmd = 'make run',
        },
        {
            repo_path = '~/.config/nvim',
            test_cmd = 'make test',
            run_cmd = 'make run',
        },
        {
            root_files = { "settings.gradle", "gradle.properties", "build.gradle" },
            test_cmd = 'gradle test -i',
            run_cmd = 'gradle run',
        },
        {
            root_files = { 'Makefile' },
            test_cmd = 'make test',
            run_cmd = 'make run',
        },
        {
            root_files = { 'Cargo.toml', 'Cargo.lock' },
            test_cmd = 'cargo test',
            run_cmd = 'cargo run',
        },
        {
            file_type = 'Makefile',
            test_cmd = 'make test',
            run_cmd = 'make run',
        },
        {
            file_type = 'rust',
            test_cmd = 'cargo test',
            run_cmd = 'cargo run',
        },
        {
            file_type = 'python',
            test_cmd = nil,
            run_cmd = "python " .. file_name,
        },
        {
            file_type = 'sh',
            test_cmd = nil,
            run_cmd = file_name,
        },
    }

    for _, entry in ipairs(command_rules) do
        if git_dir ~= nil then
            -- Check for repo path rules
            if entry.repo_path ~= nil and git_dir == entry.repo_path then
                if isTest then
                    return entry.test_cmd
                else
                    return entry.run_cmd
                end
            end

            -- Check for root file rules
            if entry.root_files ~= nil then
                for _, file in ipairs(entry.root_files) do
                    for root_file in vim.fs.dir(git_dir) do
                        if file == root_file then
                            if isTest then
                                return entry.test_cmd
                            else
                                return entry.run_cmd
                            end
                        end
                    end
                end
            end
        end

        -- Check for filetype rules
        if entry.file_type ~= nil and ft == entry.file_type then
            if isTest then
                return entry.test_cmd
            else
                return entry.run_cmd
            end
        end
    end

    -- Nothing matched
    return nil
end

local function run_new_terminal_command(cmd)
    vim.cmd("TermExec direction=vertical cmd=reset")
    vim.cmd("TermExec direction=vertical cmd=\"" .. cmd .. "\"")
end

-- Run a project specific command in a scratch terminal window
function M.TermRun()
    local cmd = get_project_command(false);
    if cmd ~= nil then
        run_new_terminal_command(cmd)
    end
end

-- Run a project specific test or build command in a scratch terminal window
function M.TermTest()
    local cmd = get_project_command(true);
    if cmd ~= nil then
        run_new_terminal_command(cmd)
    end
end

return M
