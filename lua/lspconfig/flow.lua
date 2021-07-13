local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.flow = {
  default_config = {
    cmd = { "npx", "--no-install", "flow", "lsp" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
    root_dir = function(fname)
      return util.root_pattern ".flowconfig"(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/flowtype/flow-for-vscode/master/package.json",
    description = [[
https://flow.org/
https://github.com/facebook/flow

See below for how to setup Flow itself.
https://flow.org/en/docs/install/

See below for lsp command options.

```sh
npx flow lsp --help
```
    ]],
  },
}
-- vim:et ts=2 sw=2
