---@diagnostic disable: undefined-global

-- Snippets for lua
return {
    -- s({ trig = "i",  snippetType  = "autosnippet" }, fmta("$<>$", { i(1) }))
    s({ trig = "i", regTrig = true }, fmta("$<>$", { i(1) }))
}
