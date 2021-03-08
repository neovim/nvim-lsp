local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.hls = {
  default_config = {
    cmd = {"haskell-language-server-wrapper", "--lsp"};
    filetypes = {"haskell", "lhaskell"};
    root_dir = util.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml");
    settings = {
      languageServerHaskell = {
        formattingProvider = "ormolu";
      };
    };
    lspinfo = function (cfg)
      if cfg.settings.haskell.logFile or false then
        return "logfile: "..cfg.settings.haskell.logFile
      end
      return ""
    end;
  };

  docs = {
    description = [[
https://github.com/haskell/haskell-language-server

Haskell Language Server
        ]];

    default_config = {
      root_dir = [[root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")]];
    };
  };
};

-- vim:et ts=2 sw=2
