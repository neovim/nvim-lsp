local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "denols"

configs[server_name] = {
  default_config = {
    cmd = {"deno", "lsp"};
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"};
    root_dir = util.breadth_first_root_pattern("package.json", "tsconfig.json", ".git");
    init_options = {
      enable = true;
      lint = false;
      unstable = false;
    };
  };
  docs = {
    description = [[
https://github.com/denoland/deno

Deno's built-in language server
]];
    default_config = {
      root_dir = [[breadth_first_root_pattern("package.json", "tsconfig.json", ".git")]];
    };
  };
}

-- vim:et ts=2 sw=2
