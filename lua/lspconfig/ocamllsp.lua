local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.ocamllsp = {
  default_config = {
    cmd = {"ocamllsp",};
    filetypes = {'ocaml', 'reason'};
    root_dir = util.breadth_first_root_pattern(".merlin", "package.json", ".git");
  };
  docs = {
    description = [[
https://github.com/ocaml/ocaml-lsp

`ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).

To install the lsp server in a particular opam switch:
```sh
opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git
opam install ocaml-lsp-server
```
    ]];
    default_config = {
      root_dir = [[breadth_first_root_pattern(".merlin", "package.json")]];
    };
  };
}
