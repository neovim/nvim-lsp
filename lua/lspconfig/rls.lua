local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.rls = {
  default_config = {
    cmd = { "rls" },
    filetypes = { "rust" },
    root_dir = function(fname)
      local cargo_crate_dir = util.root_pattern "Cargo.toml"(fname)
      local cmd = "cargo metadata --no-deps --format-version 1"
      if cargo_crate_dir ~= nil then
        cmd = cmd .. " --manifest-path " .. util.path.join(cargo_crate_dir, "Cargo.toml")
      end
      local cargo_metadata = vim.fn.system(cmd)
      local cargo_workspace_dir = nil
      if vim.v.shell_error == 0 then
        cargo_workspace_dir = vim.fn.json_decode(cargo_metadata)["workspace_root"]
      end
      return cargo_workspace_dir
        or cargo_crate_dir
        or util.root_pattern "rust-project.json"(fname)
        or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/rust-lang/rls

rls, a language server for Rust

See https://github.com/rust-lang/rls#setup to setup rls itself.
See https://github.com/rust-lang/rls#configuration for rls-specific settings.
All settings listed on the rls configuration section of the readme
must be set under settings.rust as follows:

```lua
nvim_lsp.rls.setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}
```

If you want to use rls for a particular build, eg nightly, set cmd as follows:

```lua
cmd = {"rustup", "run", "nightly", "rls"}
```
    ]],
  },
}
-- vim:et ts=2 sw=2
