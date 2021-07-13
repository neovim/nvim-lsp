local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local root_files = {
  ".git",
}

configs.racket_langserver = {
  default_config = {
    cmd = { "racket", "--lib", "racket-langserver" },
    filetypes = { "racket", "scheme" },
    root_dir = function(filename)
      return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
    end,
  },
  docs = {
    language_name = "Racket",
    description = [[
[https://github.com/jeapostrophe/racket-langserver](https://github.com/jeapostrophe/racket-langserver)

The Racket language server. This project seeks to use
[DrRacket](https://github.com/racket/drracket)'s public API to provide
functionality that mimics DrRacket's code tools as closely as possible.

Install via `raco`: `raco pkg install racket-langserver`
]],
  },
}
