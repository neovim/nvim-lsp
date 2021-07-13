local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "graphql"
local bin_name = "graphql-lsp"

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "server", "-m", "stream" },
    filetypes = { "graphql" },
    root_dir = function(fname)
      return util.root_pattern(".git", ".graphqlrc")(fname) or util.path.dirname(fname)
    end,
  },

  docs = {
    description = [[
https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli

`graphql-lsp` can be installed via `npm`:

```sh
npm install -g graphql-language-service-cli
```
]],
  },
}

-- vim:et ts=2 sw=2
