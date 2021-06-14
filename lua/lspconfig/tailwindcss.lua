local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'tailwindcss'
local bin_name = 'tailwindcss-language-server'

configs[server_name] = {
  default_config = {
    cmd = {bin_name, '--stdio'},
    -- filetypes copied and adjusted from tailwindcss-intellisense
    filetypes = {
      -- html
      'aspnetcorerazor',
      'astro',
      'astro-markdown',
      'blade',
      'django-html',
      'edge',
      'eelixir', -- vim ft
      'ejs',
      'erb',
      'eruby', -- vim ft
      'gohtml',
      'haml',
      'handlebars',
      'hbs',
      'html',
      -- 'HTML (Eex)',
      -- 'HTML (EEx)',
      'html-eex',
      'jade',
      'leaf',
      'liquid',
      'markdown',
      'mdx',
      'mustache',
      'njk',
      'nunjucks',
      'php',
      'razor',
      'slim',
      'twig',
      -- css
      'css',
      'less',
      'postcss',
      'sass',
      'scss',
      'stylus',
      'sugarss',
      -- js
      'javascript',
      'javascriptreact',
      'reason',
      'rescript',
      'typescript',
      'typescriptreact',
      -- mixed
      'vue',
      'svelte',
    },
    init_options = {
      userLanguages = {
        eelixir = 'html-eex',
        eruby = 'erb',
      },
    },
    root_dir = function(fname)
      return util.root_pattern('tailwind.config.js', 'tailwind.config.ts')(fname) or
      util.root_pattern('postcss.config.js', 'postcss.config.ts')(fname) or
      util.find_package_json_ancestor(fname) or
      util.find_node_modules_ancestor(fname) or
      util.find_git_ancestor(fname)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/tailwindlabs/tailwindcss-intellisense/master/packages/tailwindcss-language-server/package.json',
    description = [[
https://github.com/tailwindlabs/tailwindcss-intellisense

Tailwind CSS Language Server

**NOTE:** The current tailwindcss-language-server npm package is a different project.

Until the standalone server is published to npm, you can extract the server from the VS Code package:

```bash
curl -L -o tailwindcss-intellisense.vsix $(curl -s https://api.github.com/repos/tailwindlabs/tailwindcss-intellisense/releases/latest | grep 'browser_' | cut -d\" -f4)
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
