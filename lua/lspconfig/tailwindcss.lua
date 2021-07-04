local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "tailwindcss"
local bin_name = "tailwindcss-language-server"

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "--stdio" },
    -- filetypes copied and adjusted from tailwindcss-intellisense
    filetypes = {
      -- html
      "aspnetcorerazor",
      "astro",
      "astro-markdown",
      "blade",
      "django-html",
      "edge",
      "eelixir", -- vim ft
      "ejs",
      "erb",
      "eruby", -- vim ft
      "gohtml",
      "haml",
      "handlebars",
      "hbs",
      "html",
      -- 'HTML (Eex)',
      -- 'HTML (EEx)',
      "html-eex",
      "jade",
      "leaf",
      "liquid",
      "markdown",
      "mdx",
      "mustache",
      "njk",
      "nunjucks",
      "php",
      "razor",
      "slim",
      "twig",
      -- css
      "css",
      "less",
      "postcss",
      "sass",
      "scss",
      "stylus",
      "sugarss",
      -- js
      "javascript",
      "javascriptreact",
      "reason",
      "rescript",
      "typescript",
      "typescriptreact",
      -- mixed
      "vue",
      "svelte",
    },
    init_options = {
      userLanguages = {
        eelixir = "html-eex",
        eruby = "erb",
      },
    },
    settings = {
      tailwindCSS = {
        validate = true,
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidScreen = "error",
          invalidVariant = "error",
          invalidConfigPath = "error",
          invalidTailwindDirective = "error",
          recommendedVariantOrder = "warning",
        },
      },
    },
    on_new_config = function(new_config)
      if not new_config.settings then
        new_config.settings = {}
      end
      if not new_config.settings.editor then
        new_config.settings.editor = {}
      end
      if not new_config.settings.editor.tabSize then
        -- set tab size for hover
        new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
      end
    end,
    root_dir = function(fname)
      return util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname) or util.root_pattern(
        "postcss.config.js",
        "postcss.config.ts"
      )(fname) or util.find_package_json_ancestor(fname) or util.find_node_modules_ancestor(fname) or util.find_git_ancestor(
        fname
      )
    end,
  },
  docs = {
    language_name = "Tailwind",
    description = [[
https://github.com/tailwindlabs/tailwindcss-intellisense

Tailwind CSS Language Server

**NOTE:** The current tailwindcss-language-server npm package is a different project.

Until the standalone server is published to npm, you can extract the server from the VS Code package:

```bash
curl -L -o tailwindcss-intellisense.vsix https://github.com/tailwindlabs/tailwindcss-intellisense/releases/download/v0.6.8/vscode-tailwindcss-0.6.8.vsix
unzip tailwindcss-intellisense.vsix -d tailwindcss-intellisense
echo "#\!/usr/bin/env node\n$(cat tailwindcss-intellisense/extension/dist/server/tailwindServer.js)" > tailwindcss-language-server
chmod +x tailwindcss-language-server
```

Copy or symlink tailwindcss-language-server to somewhere in your $PATH.

Alternatively, it might be packaged for your operating system, eg.:
https://aur.archlinux.org/packages/tailwindcss-language-server/
]],
    default_config = {
      root_dir = [[root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts', 'package.json', 'node_modules', '.git')]],
    },
  },
}
