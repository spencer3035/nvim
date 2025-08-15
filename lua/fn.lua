-- Functions
-- Helper functions to be used in bindings or other modules

local M = {}

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
    print("You found my debug function! Nothing do see here")
end

--- Get the command to run for an arbitrary file open in the current buffer
--- @param isTest boolean If should return test command or run command
--- @return string? Command to run or nil if couldn't be determined
local function get_project_command(isTest)
    local ft = vim.api.nvim_get_option_value("filetype", {});
    -- Full file name
    local file_name = vim.fn.expand('%:p');
    local base_name = vim.fs.basename(file_name);
    if base_name == "Cargo.toml" then
        if isTest then
            return "cargo test"
        else
            return "cargo run"
        end
    end
    if base_name == "Makefile" then
        if isTest then
            return "make test"
        else
            return "make run"
        end
    end
    if ft == "rust" then
        if isTest then
            return "cargo test"
        else
            return "cargo run"
        end
    end

    -- Could be nil
    local git_dir = vim.fs.root(0, '.git')
    -- Traverse files around the git dir to get hints on what to run
    if git_dir then
        local base_dir_name = vim.fs.basename(git_dir)
        if base_dir_name == "nvim" then
            M.debug_function()
            return nil
        end
        for entry in vim.fs.dir(git_dir) do
            if entry == "Cargo.toml" then
                if isTest then
                    return "cargo test"
                else
                    return "cargo run"
                end
            end
            if entry == "Makefile" then
                if isTest then
                    return "make test"
                else
                    return "make run"
                end
            end
        end
    end
    return nil
end

local function run_new_terminal_command(cmd)
    vim.cmd("TermExec direction=vertical cmd=clear")
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
