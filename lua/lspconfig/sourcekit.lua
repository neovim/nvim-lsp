local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.sourcekit = {
  default_config = {
    cmd = { "xcrun", "sourcekit-lsp" },
    filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
    root_dir = util.root_pattern("Package.swift", ".git"),
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/apple/sourcekit-lsp/main/Editors/vscode/package.json",
    description = [[
https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    ]],
  },
}

-- vim:et ts=2 sw=2
