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

function M.debug_function()
    print(M.get_git_root())
    -- M.swap_arg_forward()
    -- M.swap_arg_back()
end

--- Get the git root directory of the current buffer
--- @return string? The git root directory path or nil if not in a git repository
function M.get_git_root()
    return vim.fs.root(0, '.git')
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
            root_files = { "pom.xml" },
            test_cmd = 'mvn clean test',
            run_cmd = 'mvn clean install',
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
