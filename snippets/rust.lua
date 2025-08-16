---@diagnostic disable: undefined-global

-- Snippets for rust
return {
    s("if", {
        t("if "), i(1, "true"), t({ " {", "\t" }), i(2, "// Body"), t({ ";", "}" })
    })
}
