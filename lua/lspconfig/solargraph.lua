local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local bin_name = "solargraph"
if vim.fn.has "win32" == 1 then
  bin_name = bin_name .. ".bat"
end
configs.solargraph = {
  language_name = "Ruby",
  default_config = {
    cmd = { bin_name, "stdio" },
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
    filetypes = { "ruby" },
    root_dir = util.root_pattern("Gemfile", ".git"),
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/castwide/vscode-solargraph/master/package.json",
    description = [[
https://solargraph.org/

solargraph, a language server for Ruby

You can install solargraph via gem install.

```sh
gem install --user-install solargraph
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
-- vim:et ts=2 sw=2
