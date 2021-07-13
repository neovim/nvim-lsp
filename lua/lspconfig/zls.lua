local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.zls = {
  default_config = {
    cmd = { "zls" },
    filetypes = { "zig", "zir" },
    root_dir = util.root_pattern("zls.json", ".git"),
  },
  docs = {
    description = [[
           https://github.com/zigtools/zls

           `Zig LSP implementation + Zig Language Server`.
        ]],
  },
}

-- vim:et ts=2 sw=2
