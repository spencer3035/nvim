-- Functions
-- Helper functions to be used in bindings or other modules

local M = {}

function M.reload_config()
    package.loaded.plugins = nil;
    package.loaded.settings = nil;
    package.loaded.bindings = nil;
    package.loaded.auto_commands = nil;
    package.loaded.fn = nil;
    package.loaded.work = nil;
    dofile(vim.fn.stdpath("config") .. "/init.lua")
end

function M.get_visual_selection()
    -- Use vim.fn.mode() instead of api, it accurately reflects visual modes
    local mode = vim.fn.mode()

    -- Explicitly pass the correct selection type mappings
    local type_map = {
        ['v'] = 'v',
        ['V'] = 'V',
        ['\22'] = 'b' -- This is the internal representation for <C-v> (Blockwise)
    }

    local select_type = type_map[mode] or 'v'

    -- Fetch the text region using the visual anchor 'v' and current cursor '.'
    local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = select_type })

    return table.concat(lines, "\n")
end

function M.debug_function()
    -- vim.print(t)
end

-- Extract Java fully qualified class name and add import
-- Handles: com.example.MyExample, myfunc(com.example.MyExample), myfunc(com.example.MyExample.class)
-- Works with arbitrary nesting levels (a.b.c.d.MyExample)
function M.import_java_fqdn()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- Expand selection to capture the full qualified name
    -- Pattern matches: word chars, dots, and looks for boundaries like parens, spaces, semicolons
    local before = line:sub(1, col + 1)
    local after = line:sub(col + 1)

    -- Find start: search backward for non-package characters
    local start_pos = before:reverse():find('[^%w.]')
    start_pos = start_pos and (#before - start_pos + 1) or 0

    -- Find end: search forward for non-package characters (including .class)
    local end_pos = after:find('[^%w.]')
    end_pos = end_pos and (col + end_pos) or #line + 1

    -- Extract the text
    local text = line:sub(start_pos + 1, end_pos - 1)

    -- Check if .class suffix is present and remove it for import processing
    local has_class_suffix = text:match('%.class$')
    text = text:gsub('%.class$', '')

    -- Check if it looks like a fully qualified class name (at least one dot)
    if not text:match('%.') then
        print("Not a fully qualified class name: " .. text)
        return
    end

    -- Extract package and class name
    local package, class_name = text:match('^(.+)%.([^%.]+)$')
    if not package or not class_name then
        print("Could not parse class name from: " .. text)
        return
    end

    local import_statement = 'import ' .. package .. '.' .. class_name .. ';'

    -- Determine the replacement text (preserve .class if it was present)
    local replacement_text = has_class_suffix and (class_name .. '.class') or class_name

    -- Find the last import line
    local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
    local last_import_line = 0

    for i = 1, current_line_num - 1 do
        local check_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
        if check_line and check_line:match('^import ') then
            last_import_line = i
        end
    end

    -- Check if import already exists
    local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, check_line in ipairs(all_lines) do
        if check_line == import_statement then
            print("Import already exists: " .. import_statement)
            -- Still replace the qualified name with just the class name (preserving .class if present)
            local new_line = line:sub(1, start_pos) .. replacement_text .. line:sub(end_pos)
            vim.api.nvim_set_current_line(new_line)
            return
        end
    end

    -- Insert the import after the last import (or at line 1 if no imports found)
    local insert_line = last_import_line > 0 and last_import_line or 1
    vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { import_statement })
    print("Added: " .. import_statement)

    -- Replace the fully qualified name with just the class name in the current line (preserving .class if present)
    local new_line = line:sub(1, start_pos) .. replacement_text .. line:sub(end_pos)
    vim.api.nvim_set_current_line(new_line)
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
