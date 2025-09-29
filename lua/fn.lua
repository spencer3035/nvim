-- Functions
-- Helper functions to be used in bindings or other modules

local M = {}

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
    print("You found my debug function!")
    display_code_action_details();
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
    -- Traverse files around the git dir to get hints on what to run
    if git_dir then
        local special_command = special_project_commands(git_dir, isTest);
        if special_command ~= nil then
            return special_command
        end
        local base_dir_name = vim.fs.basename(git_dir)
        if base_dir_name == "nvim" then
            M.debug_function()
            return nil
        end
        for entry in vim.fs.dir(git_dir) do
            if (entry == "settings.gradle" or entry == "gradle.properties" or entry == "build.gradle") then
                if isTest then
                    return "gradle build"
                else
                    return "gradle run"
                end
            end
            if entry == "Makefile" then
                if isTest then
                    return "make test"
                else
                    return "make run"
                end
            end
            if entry == "Cargo.toml" then
                if isTest then
                    return "cargo test"
                else
                    return "cargo run"
                end
            end
        end
    end

    if base_name == "Makefile" then
        if isTest then
            return "make test"
        else
            return "make run"
        end
    end

    if base_name == "Cargo.toml" or ft == "rust" then
        if isTest then
            return "cargo test"
        else
            return "cargo run"
        end
    end

    if ft == "python" then
        if isTest then
            return nil
        else
            return "python " .. file_name
        end
    end

    -- Fallback java commands
    if ft == "java" then
        -- TODO: javac && java
        return nil
    end

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
