local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.cmake = {
  default_config = {
    cmd = {"cmake-language-server"};
    filetypes = {"cmake"};
    root_dir = util.breadth_first_root_pattern(".git", "compile_commands.json", "build");
    init_options = {
      buildDirectory = "build",
    }
  };
  docs = {
    description = [[
https://github.com/regen100/cmake-language-server

CMake LSP Implementation
]];
    default_config = {
      root_dir = [[breadth_first_root_pattern(".git", "compile_commands.json", "build")]];
    };
  };
};

-- vim:et ts=2 sw=2
