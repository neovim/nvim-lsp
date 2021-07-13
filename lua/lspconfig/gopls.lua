local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.gopls = {
  default_config = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.mod", ".git"),
  },
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
  },
}

-- vim:et ts=2 sw=2
