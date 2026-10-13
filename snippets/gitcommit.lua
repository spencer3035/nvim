---@diagnostic disable: undefined-global

--- Get the issue key from the current Git branch, if present
---@return string? The issue key or nil if the branch has none
local function get_branch_issue_key()
    local git_root = vim.fs.root(0, '.git')
    if not git_root then
        return nil
    end

    local branch = vim.fn.systemlist({ 'git', '-C', git_root, 'branch', '--show-current' })[1]
    if vim.v.shell_error ~= 0 or not branch then
        return nil
    end

    return branch:match('%u%u%u%-%d+')
end

-- Snippets for java
return {
    -- Expand ";c" to "chore: "
    s(
        {
            trig = ";c",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            chore: <issue><stop>
            ]],
            {
                issue = f(function()
                    local issue_key = get_branch_issue_key()
                    return issue_key and (issue_key .. ' ') or ''
                end, {}),
                stop = i(0),
            }
        )
    ),
    -- Expand ";f" to "feat: "
    s(
        {
            trig = ";f",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            feat: <issue><stop>
            ]],
            {
                issue = f(function()
                    local issue_key = get_branch_issue_key()
                    return issue_key and (issue_key .. ' ') or ''
                end, {}),
                stop = i(0),
            }
        )
    ),
    -- Expand ";x" to "fix: "
    s(
        {
            trig = ";x",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            fix: <issue><stop>
            ]],
            {
                issue = f(function()
                    local issue_key = get_branch_issue_key()
                    return issue_key and (issue_key .. ' ') or ''
                end, {}),
                stop = i(0),
            }
        )
    ),
}
