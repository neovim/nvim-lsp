local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local root_files = {
  "setup.py",
  "pyproject.toml",
  "setup.cfg",
  "requirements.txt",
  ".git",
}

configs.jedi_language_server = {
  default_config = {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    root_dir = util.root_pattern(unpack(root_files)),
  },
  docs = {
    description = [[
https://github.com/pappasam/jedi-language-server

`jedi-language-server`, a language server for Python, built on top of jedi
    ]],
  },
}
-- vim:et ts=2 sw=2
