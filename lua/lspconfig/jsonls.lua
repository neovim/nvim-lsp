local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "jsonls"
local bin_name = "vscode-json-language-server"

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "--stdio" },
    filetypes = { "json" },
    init_options = {
      provideFormatter = true,
    },
    root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  },
  docs = {
    language_name = "JSON",
    -- this language server config is in VSCode built-in package.json
    package_json = "https://raw.githubusercontent.com/microsoft/vscode/master/extensions/json-language-features/package.json",
    description = [[
https://github.com/hrsh7th/vscode-langservers-extracted

vscode-json-language-server, a language server for JSON and JSON schema

`vscode-json-language-server` can be installed via `npm`:
```sh
npm i -g vscode-langservers-extracted
```

vscode-json-language-server only provides range formatting. You can map a command that applies range formatting to the entire document:

```lua
require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
```
]],
    default_config = {
      root_dir = [[root_pattern(".git", vim.fn.getcwd())]],
    },
  },
}

-- vim:et ts=2 sw=2
