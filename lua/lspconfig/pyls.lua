local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local root_files = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
}

configs.pyls = {
  default_config = {
    cmd = { "pyls" },
    filetypes = { "python" },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/palantir/python-language-server/develop/vscode-client/package.json",
    description = [[
https://github.com/palantir/python-language-server

`python-language-server`, a language server for Python.

The language server can be installed via `pipx install 'python-language-server[all]'`.

    ]],
  },
}

-- vim:et ts=2 sw=2
