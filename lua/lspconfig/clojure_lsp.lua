local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.clojure_lsp = {
  default_config = {
    cmd = { "clojure-lsp" },
    filetypes = { "clojure", "edn" },
    root_dir = function(fname)
      return util.root_pattern("project.clj", "deps.edn", ".git")(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/snoe/clojure-lsp

Clojure Language Server
]],
  },
}
-- vim:et ts=2 sw=2
