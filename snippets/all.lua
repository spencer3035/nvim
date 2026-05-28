---@diagnostic disable: undefined-global

-- Snippets for lua
return {
    -- For parnethesis with cursor on inside
    s(
        {
            trig = ";p",
            wordTrig = false,
            snippetType = "autosnippet"
        },
        fmta(
            [[
                (<stop>)
            ]],
            {
                stop = i(0),
            }
        )
    ),
    -- For single quotes with cursor on inside
    s(
        {
            trig = ";s",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
                '<stop>'
            ]],
            {
                stop = i(0),
            }
        )
    ),
    -- For double quotes with cursor on inside
    s(
        {
            trig = ";d",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
                "<stop>"
            ]],
            {
                stop = i(0),
            }
        )
    ),
    s(
        {
            trig = ";b",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
                [<stop>]
            ]],
            {
                stop = i(0),
            }
        )
    ),
}
