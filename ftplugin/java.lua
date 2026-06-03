local home = vim.fn.expand('~')
local java_path = home .. '/.sdkman/candidates/java/21.0.9-amzn'
local java17_path = home .. '~/.sdkman/candidates/java/17.0.17-amzn/'
local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
local maven_repo_path = home .. "/.m2/repository"
local launcher_path = vim.fn.expand(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local lombok_path = jdtls_path .. "/lombok.jar"

vim.opt.shiftwidth = 2;
vim.opt.signcolumn = "yes";
vim.opt.tabstop = 2;
vim.opt.expandtab = true;


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
                enabled = false, -- Disable Eclipse formatter, use google-java-format instead
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

-- Override LSP formatting to use google-java-format
local function format_with_google_java_format()
    local file = vim.api.nvim_buf_get_name(0)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.fn.system('google-java-format --replace "' .. file .. '"')
    vim.cmd('edit!')
    vim.api.nvim_win_set_cursor(0, cursor_pos)
end

-- Hook into LSP formatting
vim.api.nvim_create_autocmd('LspAttach', {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'jdtls' then
            -- Override format handler for this buffer
            vim.bo[args.buf].formatexpr = ''

            -- Create a buffer-local format command
            vim.api.nvim_buf_create_user_command(args.buf, 'Format', format_with_google_java_format, {})

            -- Override vim.lsp.buf.format() for this buffer
            local original_format = vim.lsp.buf.format
            vim.lsp.buf.format = function(opts)
                opts = opts or {}
                if vim.bo.filetype == 'java' then
                    format_with_google_java_format()
                else
                    original_format(opts)
                end
            end
        end
    end,
})
