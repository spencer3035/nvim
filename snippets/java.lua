---@diagnostic disable: undefined-global

-- Helper: split a string on commas and trim whitespace
local function split_params(raw)
    -- Remove surrounding parentheses if the user typed them
    local parts = {}
    for p in string.gmatch(raw, "[^,]+") do
        p = p:gsub("^%s+", ""):gsub("%s+$", "") -- trim
        if p ~= "" then table.insert(parts, p) end
    end
    return parts
end

-- Dynamic node that builds the @param lines
local function param_lines(args, parent, old_state, user_args)
    local return_type = args[1][1] or ""
    local input = args[2][1] or ""
    local throws = args[3][1] or ""
    local params = split_params(input)
    -- local nodes = { t({ "* hello", "" }), t({ " * world", "" }) }
    local nodes = {}

    -- Populate @params
    for _, name in ipairs(params) do
        -- Each line:   * @param <name> <placeholder>
        table.insert(nodes, t({ " * @param " .. name .. " description", "" }))
    end

    -- Populate @return
    return_type = return_type:gsub("^%s+", ""):gsub("%s+$", "")
    if return_type ~= "" and return_type ~= "void" then
        table.insert(nodes, t({ " * @return " .. return_type, "" }))
    end

    -- Populate @throws
    throws = throws:gsub("^throws", "")
    throws = throws:gsub("^%s+", ""):gsub("%s+$", "")
    if throws ~= "" then
        table.insert(nodes, t({ " * @throws " .. throws, "" }))
    end


    table.insert(nodes, t({ " */" }))

    return sn(nil, nodes);
end

-- Snippets for java
return {
    -- Expand ;fn to function with document comments
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
             *
            <doc>
            <vis> <return_type> <fn_name>(<inputs>) <throws>{
                <body>
            }<stop>
            ]],
            {
                vis = c(1, { t "public", t "private", t "public static", t "private static" }),
                return_type = i(2),
                fn_name = i(3),
                inputs = i(4),
                throws = c(5, {
                    t(""),
                    sn(nil, { t("throws "), i(1) })
                }),
                body = i(6),
                doc = d(7, param_lines, { 2, 4, 5 }),
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
