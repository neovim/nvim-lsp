local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "yamlls"
local bin_name = "yaml-language-server"

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "--stdio" },
    filetypes = { "yaml" },
    root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  },
  docs = {
    language_name = "YAML",
    package_json = "https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json",
    description = [[
https://github.com/redhat-developer/yaml-language-server

`yaml-language-server` can be installed via `npm`:
```sh
npm install -g yaml-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern(".git", vim.fn.getcwd())]],
    },
  },
}

-- vim:et ts=2 sw=2
