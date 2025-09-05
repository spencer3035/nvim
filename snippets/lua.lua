---@diagnostic disable: undefined-global

-- Snippets for lua
return {
    -- Expand ";r" to print
    s(
        {
            trig = ";r",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            print("<string>");<stop>
            ]],
            {
                string = i(1),
                stop = i(0),
            }
        )
    ),
    -- Expand to "if ... then ... end"
    s(
        {
            trig = ";if",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            if <cond> then
                <branch>
            end
            <stop>
            ]],
            {
                cond = i(1),
                branch = i(2),
                stop = i(0),
            }
        )
    ),
    s(
        {
            trig = ";ie",
            -- wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            if <cond> then
                <branch1>
            else
                <branch2>
            end
            <stop>
            ]],
            {
                cond = i(1),
                branch1 = i(2),
                branch2 = i(3),
                stop = i(0),
            }
        )
    ),
}
