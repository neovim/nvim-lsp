local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local name = "pyls_ms"

configs[name] = {
  language_name = "Python",
  default_config = {
    filetypes = { "python" },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
    settings = {
      python = {
        analysis = {
          errors = {},
          info = {},
          disabled = {},
        },
      },
    },
    init_options = {
      interpreter = {
        properties = {
          InterpreterPath = "",
          Version = "",
        },
      },
      displayOptions = {},
      analysisUpdates = true,
      asyncStartup = true,
    },
  },
  docs = {
    description = [[
https://github.com/Microsoft/python-language-server

`python-language-server`, a language server for Python.

Requires [.NET Core](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script) to run. On Linux or macOS:

```bash
curl -L https://dot.net/v1/dotnet-install.sh | sh
```

`python-language-server` can be installed via [build](https://github.com/microsoft/python-language-server/blob/master/CONTRIBUTING.md#setup).

Set cmd to point to `Microsoft.Python.languageServer.dll`.

```lua
cmd = { "dotnet", "exec", "path/to/Microsoft.Python.languageServer.dll" };
```

If the `python` interpreter is not in your PATH environment variable, set the `InterpreterPath` and `Version` properties accordingly.

```lua
InterpreterPath = "path/to/python",
Version = "3.8"
```

This server accepts configuration via the `settings` key.

    ]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}

-- vim:et ts=2 sw=2
