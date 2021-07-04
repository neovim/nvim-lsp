local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.lean3ls = {
  language_name = "Lean",
  default_config = {
    cmd = { "lean-language-server", "--stdio", "--", "-M", "4096", "-T", "100000" },
    filetypes = { "lean3" },
    root_dir = function(fname)
      return util.root_pattern "leanpkg.toml"(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    on_new_config = function(config, root)
      if not util.path.is_file(root .. "/leanpkg.toml") then
        return
      end
      if not config.cmd_cwd then
        config.cmd_cwd = root
      end
    end,
  },
  docs = {
    description = [[
https://github.com/leanprover/lean-client-js/tree/master/lean-language-server

Lean installation instructions can be found
[here](https://leanprover-community.github.io/get_started.html#regular-install).

Once Lean is installed, you can install the Lean 3 language server by running
```sh
npm install -g lean-language-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern("leanpkg.toml") or root_pattern(".git") or path.dirname]],
    },
  },
}
-- vim:et ts=2 sw=2
