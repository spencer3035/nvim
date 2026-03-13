local home = vim.fn.expand('~')
local java_path = home .. '/.sdkman/candidates/java/21.0.9-amzn'
local java17_path = home .. '~/.sdkman/candidates/java/17.0.17-amzn/'
local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
local maven_repo_path = home .. "/.m2/repository"
local launcher_path = vim.fn.expand(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local lombok_path = jdtls_path .. "/lombok.jar"


-- Override LSP's default formatting for Java to use the Spotless formatter
vim.lsp.handlers["textDocument/formatting"] = function(_, _, params, client_id, bufnr, config)
    -- If the Java file, call our Spotless formatter
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if filetype == "java" then
        FormatWithSpotless() -- Call the custom formatter instead
        return nil       -- Prevent LSP from formatting
    end
    -- Default LSP formatting if not Java
    vim.lsp.handlers["textDocument/formatting"](nil, nil, params, client_id, bufnr, config)
end

local jdtls_config = {
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
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw', '.gradle', 'pom.xml' }, { upward = true })[1]),
    settings = {
        java = {
            configuration = {
                -- runtimes = {
                --     {
                --         name = "JavaSE-21",
                --         path = java_path,
                --         default = true,
                --     },
                --     {
                --         name = "JavaSE-17",
                --         path = java17_path,
                --         default = true,
                --     },
                -- },
            },
            format = {
                profile = "GoogleStyle",
                url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
                comments = {
                    enabled = false
                },
            },
            compile = {
                nullAnalysis = {
                    mode = 'automatic',
                    -- nonnull = 'javax.annotationNonnull',
                    -- nullable = 'javax.annotation.Nullable',
                    nonnull = 'org.checkerframework.checker.nullness.qual.NonNull',
                    nullable = 'org.checkerframework.checker.nullness.qual.Nullable',
                    nonnullbydefault = '',
                }
            }
        },
    },
}

require('jdtls').start_or_attach(jdtls_config)
