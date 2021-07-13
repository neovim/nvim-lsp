local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "efm"
local bin_name = "efm-langserver"

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    root_dir = function(fname)
      return util.root_pattern ".git"(fname) or util.path.dirname(fname)
    end,
  },

  docs = {
    description = [[
https://github.com/mattn/efm-langserver

General purpose Language Server that can use specified error message format generated from specified command.
]],
  },
}
-- vim:et ts=2 sw=2
