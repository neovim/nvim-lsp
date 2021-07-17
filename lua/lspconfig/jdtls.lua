local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local handlers = require 'vim.lsp.handlers'

local server_name = 'jdtls'

local function get_java_executable()
  local executable = vim.fn.getenv('JAVA_HOME') ~= vim.NIL
    and vim.fn.expand('$JAVA_HOME/bin/java')
    or  'java'

  return vim.fn.has('win32') ~= 0
    and executable..'.exe'
    or  executable
end

local function get_workspace_dir()
  return vim.fn.getenv('$WORKSPACE') ~= vim.NIL
    and vim.fn.getenv('WORKSPACE')
    or  vim.fn.expand('$HOME/workspace')
end

local function get_jdtls_jar()
  -- The following case is for legacy cases, should we remove it?
  if vim.fn.getenv('JAR') ~= vim.NIL then
    print('Using old $JAR environment variable for JDTLS, refer to documentation and update to JDTLS_HOME')
    return vim.fn.getenv('JAR')
  end

  if vim.fn.getenv('JDTLS_HOME') == vim.NIL then
    error('JDTLS_HOME env variable not set configured')
  end

  return vim.fn.expand('$JDTLS_HOME/plugins/org.eclipse.equinox.launcher_*.jar')
end

local function get_jdtls_config()
  -- The following case is for legacy cases, should we remove it?
  if vim.fn.getenv('JDTLS_CONFIG') ~= vim.NIL then
    print('Using old $JDTLS_CONFIG environment variable for JDTLS, refer to documentation and update to JDTLS_HOME')
    return vim.fn.getenv('JDTLS_CONFIG')
  end

  if vim.fn.getenv('JDTLS_HOME') == vim.NIL then
    error('JDTLS_HOME env variable not set configured')
  end

  if vim.fn.has('unix') ~= 0 then
    return vim.fn.expand('$JDTLS_HOME/config_linux')
  elseif vim.fn.has('macunix') ~= 0 then
    return vim.fn.expand('$JDTLS_HOME/config_mac')
  elseif vim.fn.has('win32') ~= 0 then
    return vim.fn.expand('$JDTLS_HOME/config_win')
  else
    print('JDTLS Config: unknown filesystem, guessing linux')
    return vim.fn.expand('$JDTLS_HOME/config_linux')
  end
end

-- Non-standard notification that can be used to display progress
local function on_language_status(_, _, result)
  local command = vim.api.nvim_command
  command 'echohl ModeMsg'
  command(string.format('echo "%s"', result.message))
  command 'echohl None'
end

-- TextDocument version is reported as 0, override with nil for
-- the client don't think the document is newer and updates it
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end

configs[server_name] = {
  default_config = {
    cmd = {
      get_java_executable(),
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '-Xmx2G',
      '-jar', get_jdtls_jar(),
      '-configuration', get_jdtls_config(),
      '-data', get_workspace_dir(),
      '--add-modules=ALL-SYSTEM',
      '--add-opens java.base/java.util=ALL-UNNAMED',
      '--add-opens java.base/java.lang=ALL-UNNAMED',
    },
    filetypes = { 'java' },
    root_dir = util.root_pattern({
      'build.xml', -- Ant
      'pom.xml', -- Maven
      '*.gradle', -- Gradle
      'makefile', 'Makefile', -- Make
      '.git' -- Other
    }),
    init_options = {
      workspace = get_workspace_dir(),
      jvm_args = {},
      os_config = nil,
    },
    handlers = {
      -- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
      -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
      ['textDocument/codeAction'] = function(a, b, actions)
        for _, action in ipairs(actions) do
          -- TODO: (steelsojka) Handle more than one edit?
          if action.command == 'java.apply.workspaceEdit' then -- 'action' is Command in java format
            action.edit = fix_zero_version(action.edit or action.arguments[1])
          elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then -- 'action' is CodeAction in java format
            action.edit = fix_zero_version(action.edit or action.command.arguments[1])
          end
        end
        handlers['textDocument/codeAction'](a, b, actions)
      end,

      ['textDocument/rename'] = function(a, b, workspace_edit)
        handlers['textDocument/rename'](a, b, fix_zero_version(workspace_edit))
      end,

      ['workspace/applyEdit'] = function(a, b, workspace_edit)
        handlers['workspace/applyEdit'](a, b, fix_zero_version(workspace_edit))
      end,

      ['language/status'] = vim.schedule_wrap(on_language_status),
    },
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/redhat-developer/vscode-java/master/package.json',
    description = [[

https://projects.eclipse.org/projects/eclipse.jdt.ls

Language server for Java.

See project page for installation instructions.

Due to the nature of java, the settings for eclipse jdtls cannot be automatically inferred.
Please set the following environmental variables to match your installation.
You can set these locally for your project with the help of [direnv](https://github.com/direnv/direnv).

```bash
# Mandatory:
export JDTLS_HOME=/path/to/jdtls_root # Directory with the plugin and configs directories

# Optional:
export JAVA_HOME=/path/to/java_home # In case you don't have java in path or want to use a version in particular
export WORKSPACE=/path/to/workspace # Defaults to $HOME/workspace
```
    ]],
    default_config = {
    root_dir = [[util.root_pattern({
      'build.xml', -- Ant
      'pom.xml', -- Maven
      '*.gradle', -- Gradle
      'makefile', 'Makefile', -- Make
      '.git' -- Other
    })]],
    }
  }
}
