local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local cmd = {
  "julia",
  "--startup-file=no",
  "--history-file=no",
  "-e",
  [[
    using Pkg;
    Pkg.instantiate()
    using LanguageServer; using SymbolServer;
    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
    project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
    # Make sure that we only load packages from this environment specifically.
    @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
    server.runlinter = true;
    run(server);
  ]],
}

configs.julials = {
  default_config = {
    cmd = cmd,
    on_new_config = function(new_config, _)
      local server_path = vim.fn.system "julia --startup-file=no -q -e 'print(Base.find_package(\"LanguageServer\"))'"
      local new_cmd = vim.deepcopy(cmd)
      table.insert(new_cmd, 2, "--project=" .. server_path:sub(0, -19))
      new_config.cmd = new_cmd
    end,
    filetypes = { "julia" },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
  },
  docs = {
    language_name = "Julia",
    package_json = "https://raw.githubusercontent.com/julia-vscode/julia-vscode/master/package.json",
    description = [[
https://github.com/julia-vscode/julia-vscode

`LanguageServer.jl` can be installed with `julia` and `Pkg`:
```sh
julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
```
The default config lazily evaluates the location of the julia language server from the your global julia packages.
This adds a small overhead on first opening of a julia file. To avoid this overhead, replace server_path in on_new_config with
a hard-coded path to the server.

```lua
require'lspconfig'.julials.setup{
    on_new_config = function(new_config,new_root_dir)
      server_path = "/path/to/directory/containing/LanguageServer.jl/src"
      cmd = {
        "julia",
        "--project="..server_path,
        "--startup-file=no",
        "--history-file=no",
        "-e", [[
          using Pkg;
          Pkg.instantiate()
          using LanguageServer; using SymbolServer;
          depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
          project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
          # Make sure that we only load packages from this environment specifically.
          @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path
          server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
          server.runlinter = true;
          run(server);
        \]\]
    };
      new_config.cmd = cmd
    end
}
```
You can find the path to the globally installed LanguageServer.jl package with the following command:

```bash
julia -e 'print(Base.find_package("LanguageServer"))'
```

Note: the directory passed to `--project=...` should terminate with src, not LanguageServer.jl.

    ]],
  },
}

--- vim:et ts=2 sw=2
