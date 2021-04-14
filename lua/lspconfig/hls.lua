local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.hls = {
  default_config = {
    cmd = {"haskell-language-server", "--lsp"};
    filetypes = {"haskell", "lhaskell"};
    root_dir = util.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml");
    settings = {
      haskell = {
        formattingProvider = "ormolu";
      };
    };
    lspinfo = function (cfg)

      local extra = {}
      if cfg.settings.haskell.logFile or false then
        table.insert(extra, "logfile: "..cfg.settings.haskell.logFile)
      end

      function on_stdout(_, data, _)
        version = data[1]
        table.insert(extra, "version: "..version)
      end

      local opts = {
        cwd = cfg.cwd,
        stdout_buffered = true,
        on_stdout= on_stdout
      }
      local chanid = vim.fn.jobstart({cfg.cmd[1], '--version'}, opts )
      vim.fn.jobwait({chanid})
      return extra
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
