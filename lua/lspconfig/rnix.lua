local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local name = "rnix"

configs[name] = {

  default_config = {
    cmd = { "rnix-lsp" },
    filetypes = { "nix" },
    root_dir = util.find_git_ancestor,
    settings = {},
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/nix-community/rnix-lsp

A language server for Nix providing basic completion and formatting via nixpkgs-fmt.

To install manually, run `cargo install rnix-lsp`. If you are using nix, rnix-lsp is in nixpkgs.

This server accepts configuration via the `settings` key.

    ]],
  },
}

-- vim:et ts=2 sw=2
