# nvim-lspconfig

A collection of common configurations for Neovim's built-in [language server client](https://neovim.io/doc/user/lsp.html).

This repo handles automatically launching and initializing language servers that are installed on your system.

## LSP overview

Neovim supports the [Language Server Protocol (LSP)](https://microsoft.github.io/language-server-protocol/), which means it acts as a client to language servers and includes a Lua framework (`vim.lsp`) for building enhanced LSP tools.
LSP facilitates features like:

- go-to-definition
- find-references
- hover
- completion
- rename
- format
- refactor

Neovim itself provides an interface for all of these features.
The LSP client is designed to be highly extensible; it allows plugins to integrate language server features which are not yet present in Neovim core.
Examples of language server features not yet in Neovim core:

- [**auto**-completion](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) (as opposed to manual completion using [omnifunc](https://neovim.io/doc/user/options.html#'omnifunc'))
- [snippet integration](https://github.com/neovim/nvim-lspconfig/wiki/Snippets).

## Install

- Requires [Neovim HEAD/nightly](https://github.com/neovim/neovim/releases/tag/nightly) (v0.5 prerelease). Update Neovim and nvim-lspconfig before reporting an issue.
- Install nvim-lspconfig like any other plugin, e.g., using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
:Plug 'neovim/nvim-lspconfig'
```

## Quickstart

1. Install a language server, e.g., [pyright](CONFIG.md#pyright)

```bash
npm i -g pyright
```

1. Add the language server setup to your `init.vim`.
   The server name must match those found in the table of contents in [CONFIG.md](CONFIG.md).
   _NOTE_: this snippet is for `init.vim` only, this will not work in a `init.lua` file.

```vim
lua << EOF
require'lspconfig'.pyright.setup{}
eof
```

1. Create a new project.
   To work with LSP your project will need to have one of several root-directory marker files or folders.
   For instance, a `.git` folder is considered a root-directory marker.
   See [Automatically launching language servers](#Automatically-launching-language-servers) for additional info.

```bash
mkdir test_python_project
cd test_python_project
git init
touch main.py
```

1. Launch Neovim: `nvim main.py`.
   The language server will now be attached and providing diagnostics (run `:LspInfo` for details).
1. See [Keybindings and completion](#Keybindings-and-completion) for mapping useful functions and enabling 'omnifunc' (`\<C-x\>\<C-o\>`) completion

## Automatically launching language servers

In order to automatically launch a language server, lspconfig searches up the directory tree from your current buffer to find a file matching the `root_dir` pattern defined in each server's configuration.
For [pyright](CONFIG.md#pyright), this is any directory containing one of:

- `.git`,
- `setup.py`,
- `setup.cfg`,
- `pyproject.toml`, or
- `requirements.txt`.

Language servers require each project to have a `root` in order to provide completion and search across symbols that may not be defined in your current file; it also avoids having to index your entire filesystem on each startup.

## Enabling additional language servers

Most language servers can be installed in less than a minute.
Enabling a language server means:

1. Installing the language server binary: `npm install global pyright`;
1. Ensuring the language server can be found on your `PATH`: typing `pyright --version` succeeds;
1. Adding the language server configuration to your `init.vim` file:

```vim
lua << EOF
require'lspconfig'.pyright.setup{}
EOF
```

For a full list of servers, see [CONFIG.md](CONFIG.md).
This document contains installation instructions and optional customizations for each language server.
For some servers that are not on your system path, e.g., `jdtls`, `elixirls`, you will be required to manually add `cmd` as an entry in the table passed to setup.

## Keybindings and completion

nvim-lspconfig does not map keybindings or enable completion by default.
Manually-triggered completion can be provided by Neovim's built-in [https://neovim.io/doc/user/options.html#'omnifunc'](omnifunc).
For autocompletion, a general purpose [autocompletion plugin](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) is required.

Copy the following example configuration into your `init.vim` file.
The configuration provides keymaps for the most commonly used language server functions.
To suggest completions in insert-mode, press `\<C-x\>\<C-o\>`, the default binding for [omnifunc](https://neovim.io/doc/user/options.html#'omnifunc').

```lua
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
```

The `on_attach` hook is used to only activate the bindings after the language server attaches to the current buffer.

## Debugging

The two most common reasons a language server does not start or attach are:

1. The language server is not installed.
   nvim-lspconfig does not install language servers for you.
   You should be able to run the `cmd` defined in each server's lua module from the command line and see that the language server starts.
   If the `cmd` is an executable name, ensure its location is listed in your system's `PATH` variable.
1. Not triggering root detection.
   The language server will only start if it is opened in a directory, or child directory, containing a file which signals the _root_ of the project.
   Most of the time, this is a `.git` folder, but a server may define the root differently: see [CONFIG.md](CONFIG.md) or the source for the list of root directories.

`:LspInfo` provides a handy overview of your active and configured language servers.
However, `:LspInfo` can be inaccurate if any configuration changes were applied in the `on_new_config()` hook.

Before reporting a bug, check your logs and the output of `:LspInfo`.
Add the following to your `init.vim` to enable logging:

```vim
lua << EOF
vim.lsp.set_log_level("debug")
EOF
```

Attempt to run the language server again, and open the log with:

```vim
:lua vim.cmd('e'..vim.lsp.get_log_path())
```

Most of the time, the reason for failure is present in the logs.

## Built-in commands

- `:LspInfo` shows the status of active and configured language servers.

The following support tab-completion for all arguments:

- `:LspStart <config_name>` Start the requested server name.
  Will only successfully start if the command detects a root directory matching the current config.
  Pass `autostart = false` to your `.setup{}` call for a language server if you would like to launch clients solely with this command.
  Defaults to all servers matching current buffer filetype.
- `:LspStop <client_id>` Defaults to stopping all buffer clients.
- `:LspRestart <client_id>` Defaults to restarting all buffer clients.

## The wiki

Please see the [wiki](https://github.com/neovim/nvim-lspconfig/wiki) for additional topics, including:

- [Installing language servers automatically](https://github.com/neovim/nvim-lspconfig/wiki/Installing-language-servers-automatically)
- [Snippets support](https://github.com/neovim/nvim-lspconfig/wiki/Snippets-support)
- [Project local settings](https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings)
- [Recommended plugins for enhanced language server features](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)

## Windows

In order for Neovim to launch certain executables on Windows, it must append `.cmd` to the command name.
To work around this, manually append `.cmd` to the entry `cmd` in a given plugin's `setup{}` call.

## Contributions

If you are missing a language server on the list in [CONFIG.md](CONFIG.md), contributing a new configuration for it would be appreciated.
You can follow these steps:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
1. Choose a language from [the coc.nvim wiki](https://github.com/neoclide/coc.nvim/wiki/Language-servers) or [emacs-lsp](https://github.com/emacs-lsp/lsp-mode#supported-languages).
1. Create a new file at `lua/lspconfig/SERVER_NAME.lua`.
   - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/) to get started.
     Most configs are simple.
     For an extensive example see: [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/texlab.lua).
1. Ask questions on our [Discourse](https://neovim.discourse.group/c/7-category/7) or in the [Neovim Gitter](https://gitter.im/neovim/neovim).
