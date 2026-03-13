---@diagnostic disable: undefined-global

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
            chore: <stop>
            ]],
            {
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
            feat: <stop>
            ]],
            {
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
            fix: <stop>
            ]],
            {
                stop = i(0),
            }
        )
    ),
}
