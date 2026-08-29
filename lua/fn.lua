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
    -- vim.print(t)
end

--- Get the git root directory of the current buffer
--- @return string? The git root directory path or nil if not in a git repository
function M.get_git_or_file_dir()
    local git_dir = vim.fs.root(0, '.git')
    if git_dir then
        return git_dir
    end

    -- Fallback to current buffer's directory
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path and buf_path ~= "" then
        local buf_dir = vim.fn.fnamemodify(buf_path, ':p:h')
        -- Check if it's a regular file
        if vim.fn.filereadable(buf_path) == 1 then
            return buf_dir
        end
    end
    -- nothing found
    return nil
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

-- Run a project specific command in a scratch terminal window
function M.TermRunCmd()
    return get_project_command(false);
end

-- Run a project specific test or build command in a scratch terminal window
function M.TermTestCmd()
    return get_project_command(true);
end

--- Convert GitHub URLs to local paths if USE_LOCAL_PLUGINS is set
--- @param url string GitHub URL or local path
--- @return string The original URL or converted local path
function M.maybe_local_plugin(url)
    vim.g.LOCAL_PLUGINS_PATH = "/home/littels/.local/share/nvim/site/pack/core/opt"
    vim.g.USE_LOCAL_PLUGINS = false
    local use_local = vim.g.USE_LOCAL_PLUGINS

    if not use_local then
        return url
    end

    -- If it's already a local path, return as-is
    if not url:match('^https?://') then
        return url
    end

    -- Parse GitHub URL and convert to local path
    local org, repo = url:match('github%.com/([^/]+)/([^/]+)/?$')
    if org and repo then
        local base_path = vim.g.LOCAL_PLUGINS_PATH or (vim.fn.expand('~') .. '/dev/git')
        return base_path .. '/' .. repo
    end

    return url
end

return M
