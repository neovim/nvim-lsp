local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"

local name = "java_language_server"

configs[name] = {
  language_name = "Java",
  default_config = {
    cmd = {},
    filetypes = { "java" },
    root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git"),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/georgewfraser/java-language-server

Java language server

Point `cmd` to `lang_server_linux.sh` or the equivalent script for macOS/Windows provided by java-language-server
]],
  },
}
