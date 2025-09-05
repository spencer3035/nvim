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
    -- Expand boilerplate for struct/enum
    s(
        {
            trig = ";im",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            #[derive(Debug)]
            <type> <name> {
                <members>
            }

            impl <name_dupe> {
                fn new() ->> Self {
                    <stop>todo!();
                }
            }
            ]],
            {
                type = c(1, {
                    t "struct",
                    t "enum",
                }),
                name = i(2),
                name_dupe = d(
                    4,
                    function(args)
                        vim.inspect(args)
                        return sn(nil, {
                            t(args[1])
                        })
                    end,
                    { 2 }
                ),
                members = i(3),
                stop = i(0),
            }
        )
    ),
    -- Expand ";if" to full if statement
    s(
        {
            trig = ";if",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
            if <cond> {
                <stop>;
            }
            ]],
            {
                cond = i(1),
                stop = i(0),
            }
        )
    ),
    -- Expand ";r" to "println!("");"
    s(
        {
            trig = ";r",
            wordTrig = true,
            snippetType = "autosnippet"
        },
        fmta(
            [[
                println!("<string>");<stop>
            ]],
            {
                string = i(1),
                stop = i(0),
            }
        )
    ),
}
