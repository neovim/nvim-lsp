local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local last_root_dir = nil
local gopath = os.getenv("GOPATH")
if gopath == nil then gopath = "" end

local function prev_server_for_pkgmod(fname)
  local fullpath = vim.fn.expand(fname, ":p")
  if string.find(fullpath, gopath.."/pkg/mod") and last_root_dir ~= nil then
    return last_root_dir
  end
  last_root_dir = util.root_pattern("go.mod", ".git")(fname)
  return last_root_dir
end

configs.gopls = {
  default_config = {
    cmd = {"gopls"};
    filetypes = {"go", "gomod"};
    root_dir = prev_server_for_pkgmod;
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.

Note that the default config attaches files from the modules directory to the previous `gopls` instance if it exists (like vscode does, see [the issue](https://github.com/neovim/nvim-lspconfig/issues/804)).<br>
If you'd like to change this behavior, feel free to override the default config.
]];
    default_config = {
      root_dir = [[
root_pattern("go.mod", ".git") or the last gopls root_dir for the `$GOPATH/pkg/mod`
      ]];
    };
  };
}
-- vim:et ts=2 sw=2
