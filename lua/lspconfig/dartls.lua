local util = require "lspconfig/util"
local configs = require "lspconfig/configs"

local server_name = "dartls"
local bin_name = "dart"

local find_dart_sdk_root_path = function()
  if vim.fn["executable"] "flutter" == 1 then
    local flutter_path = vim.fn["resolve"](vim.fn["exepath"] "flutter")
    local flutter_bin = vim.fn["fnamemodify"](flutter_path, ":h")
    return flutter_bin .. "/cache/dart-sdk/bin/dart"
  elseif vim.fn["executable"] "dart" == 1 then
    return vim.fn["resolve"](vim.fn["exepath"] "dart")
  else
    return ""
  end
end

local analysis_server_snapshot_path = function()
  local dart_sdk_root_path = vim.fn["fnamemodify"](find_dart_sdk_root_path(), ":h")
  local snapshot = dart_sdk_root_path .. "/snapshots/analysis_server.dart.snapshot"

  if vim.fn["has"] "win32" == 1 or vim.fn["has"] "win64" == 1 then
    snapshot = snapshot:gsub("/", "\\")
  end

  return snapshot
end

configs[server_name] = {
  default_config = {
    cmd = { bin_name, analysis_server_snapshot_path(), "--lsp" },
    filetypes = { "dart" },
    root_dir = function(fname)
      return util.root_pattern "pubspec.yaml"(fname) or util.path.dirname(fname)
    end,
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = false,
      suggestFromUnimportedLibraries = true,
      closingLabels = false,
      outline = false,
      flutterOutline = false,
    },
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/Dart-Code/Dart-Code/master/package.json",
    description = [[
https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec

Language server for dart.
]],
  },
}
-- vim:et ts=2 sw=2
