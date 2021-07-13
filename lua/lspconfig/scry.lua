local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.scry = {
  default_config = {
    cmd = { "scry" },
    filetypes = { "crystal" },
    root_dir = function(fname)
      return util.root_pattern "shard.yml"(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/crystal-lang-tools/scry

Crystal language server.
]],
  },
}

-- vim:et ts=2 sw=2
