local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.ghcide = {
  default_config = {
    cmd = { "ghcide", "--lsp" },
    filetypes = { "haskell", "lhaskell" },
    root_dir = function(fname)
      return util.root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml")(fname)
        or util.path.dirname(fname)
    end,
  },

  docs = {
    description = [[
https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.
"ghcide" isn't for end users now. Use "haskell-language-server" instead of "ghcide".
]],
  },
}
-- vim:et ts=2 sw=2
