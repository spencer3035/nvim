local home = vim.fn.expand('~')
local java_path = home .. '/.sdkman/candidates/java/21.0.9-amzn'
local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
local maven_repo_path = home .. "/.m2/repository"
local launcher_path = vim.fn.expand(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local lombok_path = jdtls_path .. "/lombok.jar"

---@type vim.lsp.Config
local config = {
    cmd = {
        java_path .. "/bin/java", -- Path to your specific Java version
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util.concurrent=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok_path,
        "-classpath", maven_repo_path, -- Add Maven repository to classpath
        "-jar", launcher_path,
        "-configuration", jdtls_path .. "/config_linux",
        "-data", home .. "/.local/share/nvim/jdtls_workspace",
    },
    ---@type lspconfig.settings.jdtls
    settings = {
        java = {
            compile = {
                nullAnalysis = {
                    mode = "interactive",
                }
            },
            format = {},
        }
    }
}

return config
