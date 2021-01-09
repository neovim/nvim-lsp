local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.hls = {
  default_config = {
    cmd = {"haskell-language-server-wrapper", "--lsp"};
    filetypes = {"haskell", "lhaskell"};
    root_dir = util.breadth_first_root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml");
  };

  docs = {
    description = [[
https://github.com/haskell/haskell-language-server

Haskell Language Server
        ]];

    default_config = {
      root_dir = [[breadth_first_root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")]];
    };
  };
};

-- vim:et ts=2 sw=2
