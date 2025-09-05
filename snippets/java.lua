---@diagnostic disable: undefined-global

-- Snippets for java
return {
    -- Expand "p" to "System.out.println("");"
    s(
        {
            trig = ";r",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        {
            t("System.out.println(\""),
            i(1),
            t({ "\");", "" }),
            i(0),
        }
    ),
}
