local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "lemminx"
local bin_name = "org.eclipse.lemminx-uber.jar"

configs[name] = {
  default_config = {
    cmd = {
      bin_name
    },
    filetypes = {"xml"};
    root_dir = function(filename)
      return util.root_pattern(".git") or util.path.dirname(filename)
    end;
  };
  docs = {
    description = [[
https://github.com/eclipse/lemminx

Requirements:
 - Java

Features:
 - textDocument/codeAction
 - textDocument/completion
 - textDocument/documentHighlight
 - textDocument/documentLink
 - textDocument/documentSymbol
 - textDocument/foldingRanges
 - textDocument/formatting
 - textDocument/hover
 - textDocument/rangeFormatting
 - textDocument/rename


Build from source, or download from eclipse:
```bash
LATEST=$(curl --silent https://repo.eclipse.org/content/repositories/lemminx-releases/org/eclipse/lemminx/org.eclipse.lemminx/maven-metadata.xml | grep "release" | cut -d '>' -f2 | cut -d '<' -f1)

curl -L -o org.eclipse.lemminx-uber.jar https://repo.eclipse.org/content/repositories/lemminx-releases/org/eclipse/lemminx/org.eclipse.lemminx/$LATEST/org.eclipse.lemminx-$LATEST-uber.jar
```

Set path to the jar-file as the `cmd`-path:

```lua
require'lspconfig'.lemminx.setup{
    -- Unix
    cmd = { "java", "-jar", "/path/to/downloaded/org.eclipse.lemminx-uber.jar" },
    ...
}
```
]];
  };
}

-- vim:et ts=2 sw=2
