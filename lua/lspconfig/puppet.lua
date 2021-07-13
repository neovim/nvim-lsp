local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "puppet"
local bin_name = "puppet-languageserver"

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "--stdio" },
    filetypes = { "puppet" },
    root_dir = util.root_pattern("manifests", ".puppet-lint.rc", "hiera.yaml", ".git"),
  },
  docs = {
    description = [[
LSP server for Puppet.

Installation:

- Clone the editor-services repository:
    https://github.com/puppetlabs/puppet-editor-services

- Navigate into that directory and run: `bundle install`

- Install the 'puppet-lint' gem: `gem install puppet-lint`

- Add that repository to $PATH.

- Ensure you can run `puppet-languageserver` from outside the editor-services directory.
]],
  },
}

-- vim:et ts=2 sw=2
