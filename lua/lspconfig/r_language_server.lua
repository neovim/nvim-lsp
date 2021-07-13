local util = require "lspconfig/util"
local configs = require "lspconfig/configs"

configs.r_language_server = {
  default_config = {
    cmd = { "R", "--slave", "-e", "languageserver::run()" },
    filetypes = { "r", "rmd" },
    root_dir = util.find_git_ancestor,
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/REditorSupport/vscode-r-lsp/master/package.json",
    description = [[
    [languageserver](https://github.com/REditorSupport/languageserver) is an
    implementation of the Microsoft's Language Server Protocol for the R
    language.

    It is released on CRAN and can be easily installed by

    ```R
    install.packages("languageserver")
    ```
    ]],
  },
}

-- vim:et ts=2 sw=2
