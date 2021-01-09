local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = 'omnisharp'

configs[server_name] = {
  default_config = {
    filetypes = {"cs", "vb"};
    root_dir = util.breadth_first_root_pattern("*.csproj", "*.sln");
    init_options = {
    };
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/omnisharp/omnisharp-roslyn
OmniSharp server based on Roslyn workspaces

`omnisharp-roslyn` can be installed by downloading and extracting a release from [here](https://github.com/OmniSharp/omnisharp-roslyn/releases).
Omnisharp can also be built from source by following the instructions [here](https://github.com/omnisharp/omnisharp-roslyn#downloading-omnisharp).

**By default, omnisharp-roslyn doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of you unzipped .

```lua
local pid = vim.fn.getpid()
local omnisharp_bin = "/path/to/omnisharp/OmniSharp"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
require'lspconfig'.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
    ...
}
```
]];
    default_config = {
      root_dir = [[breadth_first_root_pattern(".csproj", ".sln")]];
    };
  };
}

-- vim:et ts=2 sw=2
