local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.racket_langserver = {
  default_config = {
    cmd = { "racket", "--lib", "racket-langserver" },
    filetypes = { "racket", "scheme" },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
[https://github.com/jeapostrophe/racket-langserver](https://github.com/jeapostrophe/racket-langserver)

The Racket language server. This project seeks to use
[DrRacket](https://github.com/racket/drracket)'s public API to provide
functionality that mimics DrRacket's code tools as closely as possible.

Install via `raco`: `raco pkg install racket-langserver`
]],
  },
}

-- vim:et ts=2 sw=2
