---@diagnostic disable: undefined-global

-- Cheat sheet of imported commands
-- ls = require("luasnip")
-- s = ls.snippet
-- sn = ls.snippet_node
-- isn = ls.indent_snippet_node
-- t = ls.text_node
-- i = ls.insert_node
-- f = ls.function_node
-- c = ls.choice_node
-- d = ls.dynamic_node
-- r = ls.restore_node
-- events = require("luasnip.util.events")
-- ai = require("luasnip.nodes.absolute_indexer")
-- extras = require("luasnip.extras")
-- l = extras.lambda
-- rep = extras.rep
-- p = extras.partial
-- m = extras.match
-- n = extras.nonempty
-- dl = extras.dynamic_lambda
-- fmt = require("luasnip.extras.fmt").fmt
-- fmta = require("luasnip.extras.fmt").fmta
-- conds = require("luasnip.extras.expand_conditions")
-- postfix = require("luasnip.extras.postfix").postfix
-- types = require("luasnip.util.types")
-- parse = require("luasnip.util.parser").parse_snippet
-- ms = ls.multi_snippet
-- k = require("luasnip.nodes.key_indexer").new_key


-- Snippets for rust
return {
    -- Expand "if" to full if statement
    s("if",
        fmt(
            [[
            if {cond} {{
                {stop};
            }}
            ]],
            {
                cond = i(1),
                stop = i(0),
            }
        )
    ),
    -- Expand "p" to "println!("");"
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
            t("println!(\""),
            i(0),
            t("\");"),
        }
    ),
}
