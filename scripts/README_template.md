# nvim-lspconfig

Collection of common configurations for the [Nvim LSP client](https://neovim.io/doc/user/lsp.html).

## Best-effort, unsupported

The configurations here are strictly **best effort and unsupported**.

This repo is (1) a place for Nvim LSP users to collaboratively provide starting
examples for the many LSP backends out there, and (2) a reference for the
current best practice (or most popular) regarding choice of server, setup, etc.

## Requires Nvim 0.5 HEAD

While Nvim LSP undergoes development, the configs in this repo assume that you
are using the latest [Nvim HEAD/nightly build](https://github.com/neovim/neovim/releases/tag/nightly).

Update Nvim and nvim-lspconfig before reporting an issue.

## Contributions

It's up to you to send improvements so that these configs align with current
best practices for a given language.

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
   Ask questions in [Neovim Gitter](https://gitter.im/neovim/neovim).
2. Choose a language from [the coc.nvim wiki](https://github.com/neoclide/coc.nvim/wiki/Language-servers) or
  [emacs-lsp](https://github.com/emacs-lsp/lsp-mode#supported-languages).
3. Create a new file at `lua/lspconfig/SERVER_NAME.lua`.
   - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/)
     to get started. Most configs are simple. For an extensive example see
     [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/texlab.lua).

## Install

- Requires [Nvim HEAD/nightly](https://github.com/neovim/neovim/releases/tag/nightly) (v0.5 prerelease).
- nvim-lspconfig is just a plugin. Install it like any other Vim plugin, e.g. with [vim-plug](https://github.com/junegunn/vim-plug):
  ```
  :Plug 'neovim/nvim-lspconfig'
  ```
- Call `:packadd nvim-lspconfig` in your vimrc if you installed nvim-lspconfig to `'packpath'` or if you use a package manager such as minpac.

## Usage

Each config provides a `setup()` function, to initialize the server with
reasonable defaults and some server-specific things like commands or different
diagnostics.

```lua
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
require'lspconfig'.<config>.setup{name=…, settings = {…}, …}
```

If you want to add this to your vimrc, you will need to enclose it in a `lua` block.

```vim
lua <<EOF
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
require'lspconfig'.<config>.setup{name=…, settings = {…}, …}
EOF
```

Find the [config](#configurations) for your language, then paste the example
given there to your `init.vim`. **All examples are given in Lua,** see `:help
:lua-heredoc` to use Lua from your init.vim.

Some configs may define additional server-specific functions, e.g. the `texlab`
config provides `lspconfig.texlab.buf_build({bufnr})`.

If you want to see the location of log file, you can run this in neovim:

```
:lua print(vim.lsp.get_log_path())
```

### Example: using the defaults

To use the defaults, just call `setup()` with an empty `config` parameter.
For the `gopls` config, that would be:

```lua
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
require'lspconfig'.gopls.setup{}
```

### Example: override some defaults

To set some config properties at `setup()`, specify their keys. For example to
change how the "project root" is found, set the `root_dir` key:

```lua
local lspconfig = require'lspconfig'
lspconfig.gopls.setup{
  root_dir = lspconfig.util.root_pattern('.git');
}
```

The [documentation](#configurations) for each config lists default values and
additional optional properties.

```lua
local lspconfig = require'lspconfig'
lspconfig.texlab.setup{
  name = 'texlab_fancy';
  log_level = vim.lsp.protocol.MessageType.Log;
  message_level = vim.lsp.protocol.MessageType.Log;
  settings = {
    latex = {
      build = {
        onSave = true;
      }
    }
  }
}
```

### Example: custom config

To configure a custom/private server, just require `lspconfig/configs` and do
the same as we do if we were adding it to the repository itself.

1. Define the config: `configs.foo_lsp = { … }`
2. Call `setup()`: `require'lspconfig'.foo_lsp.setup{}`

```lua
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
-- Check if it's already defined for when I reload this file.
if not lspconfig.foo_lsp then
  configs.foo_lsp = {
    default_config = {
      cmd = {'/home/ashkan/works/3rd/lua-language-server/run.sh'};
      filetypes = {'lua'};
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
      end;
      settings = {};
    };
  }
end
lspconfig.foo_lsp.setup{}
```

### Example: override default config

If you want to change default configs for all servers, you can override default_config like this.

```lua
local lspconfig = require'lspconfig'
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  { log_level = lsp.protocol.MessageType.Warning.Error }
)
```

### Installing a language server

Configs may provide an `install()` function. Then you can use
`:LspInstall {name}` to install the required language server.
For example, to install the Elm language server:

    :LspInstall elmls

Use `:LspInstallInfo` to see install info.

    :LspInstallInfo

## setup() function

The `setup()` interface:

```
lspconfig.SERVER.setup{config}

  The `config` parameter has the same shape as that of
  |vim.lsp.start_client()|, with these additions and changes:

  {cmd}
    Required for all servers.
    Table containing the server daemon executable name as the first element and
    optional additional commandline arguments as subsequent elements.

  {root_dir}
    Required for some servers, optional for others.
    Function of the form `function(filename, bufnr)`.
    Called on new candidate buffers being attached-to.
    Returns either a root_dir or nil.

    If a root_dir is returned, then this file will also be attached. You
    can optionally use {filetype} to help pre-filter by filetype.

    If a root_dir is returned which is unique from any previously returned
    root_dir, a new server will be spawned with that root_dir.

    If nil is returned, the buffer is skipped.

    See |lspconfig.util.search_ancestors()| and the functions which use it:
    - |lspconfig.util.root_pattern(patterns...)| finds an ancestor which
    - contains one of the files in `patterns...`. This is equivalent
      to coc.nvim's "rootPatterns"
    - Related utilities for common tools:
      - |lspconfig.util.find_git_root()|
      - |lspconfig.util.find_node_modules_root()|
      - |lspconfig.util.find_package_json_root()|

  {name}
    Defaults to the server's name.

  {filetypes}
    Set of filetypes to filter for consideration by {root_dir}.
    May be empty.
    Server may specify a default value.

  {log_level}
    controls the level of logs to show from window/logMessage notifications. Defaults to
    vim.lsp.protocol.MessageType.Warning instead of
    vim.lsp.protocol.MessageType.Log.

  {message_level}
    controls the level of messages to show from window/showMessage notifications. Defaults to
    vim.lsp.protocol.MessageType.Warning instead of
    vim.lsp.protocol.MessageType.Log.

  {settings}
    Map with case-sensitive keys corresponding to `workspace/configuration`
    event responses.
    We also notify the server *once* on `initialize` with
    `workspace/didChangeConfiguration`.
    If you change the settings later on, you must emit the notification
    with `client.workspace_did_change_configuration({settings})`
    Example: `settings = { keyName = { subKey = 1 } }`

  {on_attach}
    `function(client)` executed with the current buffer as the one the {client}
    is being attached-to. This is different from
    |vim.lsp.start_client()|'s on_attach parameter, which passes the {bufnr} as
    the second parameter instead. Useful for doing buffer-local setup.

  {on_new_config}
    `function(new_config, new_root_dir)` will be executed after a new configuration has been
    created as a result of {root_dir} returning a unique value. You can use this
    as an opportunity to further modify the new_config or use it before it is
    sent to |vim.lsp.start_client()|.

    Example:
    When running a [clangd](#clangd) language server, an implementation of this
    function can be useful to provide the location of the
    `compile_commands.json` using the `--compile-commands-dir` argument.

    on_new_config = function(new_config)
        local root_dir = new_config.root_dir(vim.api.nvim_buf_get_name(0),
                                             vim.api.nvim_get_current_buf())
        local build_path = string.gsub(root_dir, 'src', 'build')
        local args = {('--compile-commands-dir=%s'):format(build_path)}
        vim.list_extend(new_config.cmd, args)
    end;
```

# Configurations

The following LSP configs are included. Follow a link to find documentation for
that config.

{{implemented_servers_list}}

{{lsp_server_details}}
