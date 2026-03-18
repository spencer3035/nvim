---@diagnostic disable: undefined-global

-- Snippets for bash/sh
return {
    -- Expand ";if" to full if statement
    s(
        {
            trig = ";if",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            if <cond> ; then
                <stop>
            fi
            ]],
            {
                cond = i(1),
                stop = i(0),
            }
        )
    ),
    s(
        {
            trig = ";for",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            for <item> in <list> ; do
                <stop>
            done
            ]],
            {
                item = i(1),
                list = i(2),
                stop = i(0),
            }
        )
    ),
}
