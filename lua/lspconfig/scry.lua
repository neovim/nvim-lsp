local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.scry = {
  default_config = {
    cmd = {'scry'},
    filetypes = {'crystal'},
    root_dir = function(fname)
      return util.breadth_first_root_pattern('shard.yml') or
        util.find_git_ancestor(fname) or
        util.path.dirname(fname)
    end
  },
  docs = {
      description = [[
https://github.com/crystal-lang-tools/scry

Crystal language server.
]],
      default_config = {
          root_dir = [[breadth_first_root_pattern('shard.yml', '.git') or dirname]]
      }
  }
}
