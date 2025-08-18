---@diagnostic disable: undefined-global

-- Snippets for java
return {
    -- Expand "p" to "System.out.println("");"
    s(
        {
            -- Regex to capture an isolated 'p' preceeded by whitespace, we will replace 'p', but
            -- not the whitespace with a print statement
            trig = "^(%s*)p ",
            regTrig = true,
            wordTrig = false,
            snippetType = "autosnippet"
        },
        {
            -- Return the indented part
            f(function(_, snip)
                return snip.captures[1]
            end),
            t("System.out.println(\""),
            i(0),
            t("\");"),
        }
    ),
}
