local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

configs.tflint = {
  language_name = "Terraform",
  default_config = {
    cmd = { "tflint", "--langserver" },
    filetypes = { "terraform" },
    root_dir = util.root_pattern(".terraform", ".git", ".tflint.hcl"),
  },
  docs = {
    description = [[
https://github.com/terraform-linters/tflint

A pluggable Terraform linter that can act as lsp server.
Installation instructions can be found in https://github.com/terraform-linters/tflint#installation.
]],
    default_config = {
      root_dir = [[root_pattern(".terraform", ".git", ".tflint.hcl")]],
    },
  },
}
-- vim:et ts=2 sw=2
