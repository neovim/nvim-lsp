local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "phpactor"

configs[server_name] = {
  default_config = {
    cmd = { "phpactor", "language-server" },
    filetypes = { "php" },
    root_dir = util.root_pattern("composer.json", ".git"),
  },
  docs = {
    description = [[
https://github.com/phpactor/phpactor

Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
]],
  },
}

-- vim:et ts=2 sw=2
