---@diagnostic disable: undefined-global

-- Snippets for java
return {
    -- Expand ;fn to function
    s(
        {
            trig = ";fn",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            /**
             * Brief description of function
             * <inputs_doc>
             * <return_doc>
             * <throws_doc>
             */
            <vis> <return_type> <fn_name>(<inputs>) <throws> {
                <body>
            }<stop>
            ]],
            {
                vis = c(1, { t "public", t "private" }),
                return_type = i(2),
                fn_name = i(3),
                inputs = i(4),
                throws = c(5, { t "", t "throws" }),
                body = i(6),
                inputs_doc = t "",
                return_doc = t "",
                throws_doc = t "",
                stop = i(0),
            }
        )
    ),
    -- Expand ;if to if statement
    s(
        {
            trig = ";if",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            if (<cond>) {
                <branch>
            }<stop>
            ]],
            {
                cond = i(1),
                branch = i(2),
                stop = i(0),
            }
        )
    ),
    -- Expand ";r" to "System.out.println("");"
    s(
        {
            trig = ";r",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            System.out.println("<string>");<stop>
            ]],
            {
                string = i(1),
                stop = i(0),
            }
        )
    ),
}
