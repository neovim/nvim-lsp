local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "html"
local bin_name = "vscode-html-language-server"

local root_pattern = util.root_pattern "package.json"

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "--stdio" },
    filetypes = { "html" },
    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end,
    settings = {},
    init_options = {
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { "html", "css", "javascript" },
    },
  },
  docs = {
    language_name = "HTML",
    description = [[
https://github.com/hrsh7th/vscode-langservers-extracted

`vscode-html-language-server` can be installed via `npm`:
```sh
npm i -g vscode-langservers-extracted
```

Neovim does not currently include built-in snippets. `vscode-html-language-server` only provides completions when snippet support is enabled.
To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.

```lua
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
  capabilities = capabilities,
}
```
]],
  },
}

-- vim:et ts=2 sw=2
