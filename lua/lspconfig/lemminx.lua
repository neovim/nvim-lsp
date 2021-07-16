local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "lemminx"
local bin_name = "lemminx"

configs[name] = {
  default_config = {
    cmd = {
      bin_name
    },
    filetypes = {"xml", "xsd", "svg"};
    root_dir = function(filename)
      return util.root_pattern(".git")(filename) or util.path.dirname(filename)
    end;
  };
  docs = {
    description = [[
https://github.com/eclipse/lemminx

Features:
 - textDocument/codeAction
 - textDocument/completion
 - textDocument/definition (jump between opening and closing tags)
 - textDocument/documentHighlight
 - textDocument/documentLink
 - textDocument/documentSymbol
 - textDocument/foldingRanges
 - textDocument/formatting
 - textDocument/hover
 - textDocument/rangeFormatting
 - textDocument/rename
 - textDocument/typeDefinition (link from an XML element to the definition of the element in the schema file)

The easiest way to install the server is to get a binary at https://download.jboss.org/jbosstools/vscode/stable/lemminx-binary/ and place it in your PATH.

NOTE to macOS users: Binaries from unidentified developers are blocked by default. If you trust the downloaded binary from jboss.org, run it once, cancel the prompt, then remove the binary from Gatekeeper quarantine with `xattr -d com.apple.quarantine lemminx`. It should now run without being blocked.

]];
  };
}

-- vim:et ts=2 sw=2
