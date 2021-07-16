local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.terraformlsp = {
  default_config = {
    cmd = {"terraform-lsp"};
    filetypes = {"terraform", "hcl"};
    root_dir = util.root_pattern(".terraform", ".git");
  };
  docs = {
    description = [[
https://github.com/juliosueiras/terraform-lsp

Terraform language server
Download a released binary from https://github.com/hashicorp/terraform-ls/releases.
]];
    default_config = {
      root_dir = [[root_pattern(".terraform", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
