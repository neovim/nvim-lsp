---
name: Bug report
about: Report a problem in nvim-lsp
title: ''
labels: bug

---

<!-- Before reporting: search existing issues and ensure you are running the latest nightly of neovim and the latest version of nvim-lspconfig. Note that this repository implements configuration and initialization of language servers. Implementation of the language server spec itself is located in the neovim core repository-->

- `nvim --version`:
- nvim-lsp version(commit hash):
- What language server? (If the problem is related to a specific language server):
- Can you reproduce this behavior on other language server clients? (vscode, languageclient-neovim, coc.nvim, etc.):
- Can you reproduce this behavior on other language servers offered in the nvim-lspconfig repo? (pyls -> pyright):
- Is the problem isolated to a particular language server?:
- Can you reproduce this behavior with a previous version of a particular language server?:
- Operating system/version:

### How to reproduce the problem from neovim startup

### Actual behaviour

### Expected behaviour

### Minimal init.vim or init.lua and code sample
<!-- You can download a minimal_init.lua from here 
      curl -fLO https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/test/minimal_init.lua 
      After editing to include your language server, run neovim with nvim -u minimal_init.lua -->

### Health check
<details>
<summary>Checkhealth result</summary>
<!-- Run `:checkhealth lspconfig` and paste the result here-->
</details>

### LSP log
<!-- If not using the minimal_init.lua please add vim.lsp.set_log_level("debug") to your lua block 
     in init.vim and paste a link to your log file, located at  $HOME/.cache/nvim/lsp.log (formerly $HOME/.local/share/nvim/lsp.log) -->
<details>
<summary>Log file</summary>
<!-- past you log between here -->
</details>
