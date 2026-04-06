---@diagnostic disable: undefined-global

-- Snippets for markdown
return {
    -- Expand ";c" to markdown checkbox
    s(
        {
            trig = ";c",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            - [ ] <stop>
            ]],
            {
                stop = i(0),
            }
        )
    ),
    -- Expand ";x" to markdown checkbox (checked)
    s(
        {
            trig = ";x",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            - [x] <stop>
            ]],
            {
                stop = i(0),
            }
        )
    ),
}
