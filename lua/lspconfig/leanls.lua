local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.leanls = {
  default_config = {
    cmd = { 'lean', '--server' },
    filetypes = { 'lean' },
    root_dir = function(fname)
      return util.root_pattern 'leanpkg.toml'(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    on_new_config = function(config, root)
      if not util.path.is_file(root .. '/leanpkg.toml') then
        return
      end
      if not config.cmd_cwd then
        config.cmd_cwd = root
      end
    end,
  },
  docs = {
    description = [[
https://github.com/leanprover/lean4

Lean installation instructions can be found
[here](https://leanprover-community.github.io/get_started.html#regular-install).

The Lean 4 language server is built-in with a Lean 4 install
(and can be manually run with, e.g., `lean --server`).

Note: that if you're using [lean.nvim](https://github.com/Julian/lean.nvim),
that plugin fully handles the setup of the Lean language server,
and you shouldn't set up `leanls` both with it and `lspconfig`.
    ]],
    default_config = {
      root_dir = [[root_pattern("leanpkg.toml") or root_pattern(".git") or path.dirname]],
    },
  },
}
-- vim:et ts=2 sw=2
