local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.nimls = {
  language_name = "Nim",
  default_config = {
    cmd = { "nimlsp" },
    filetypes = { "nim" },
    root_dir = function(fname)
      return util.root_pattern "*.nimble"(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/pragmagic/vscode-nim/master/package.json",
    description = [[
https://github.com/PMunch/nimlsp
`nimlsp` can be installed via the `nimble` package manager:
```sh
nimble install nimlsp
```
    ]],
    default_config = {
      root_dir = [[root_pattern(".git") or os_homedir]],
    },
  },
}
