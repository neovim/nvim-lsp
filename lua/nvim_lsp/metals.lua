local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local server_name = "metals"
local bin_name = "metals"

local function make_installer()
  local install_dir = util.path.join{util.base_install_dir, server_name}
  local metals_bin = util.path.join{install_dir, bin_name}
  local X = {}
  function X.install()
    local install_info = X.info()
    if install_info.is_installed then
      print(server_name, "is already installed")
      return
    end
    if not (util.has_bins("curl")) then
      error('Need "curl" to install this.')
      return
    end
    if not (util.has_bins("java")) then
      error('Need "JDK" to install this.')
      return
    end
    local coursier_exe
    if not (util.has_bins("cs")) then
      coursier_exe = install_dir .. "/coursier"
      local download_cmd = string.format("curl -fLo %s --create-dirs https://git.io/coursier-cli", coursier_exe)
      local chmod_cmd = string.format("chmod +x %s", coursier_exe)
      vim.fn.system(download_cmd)
      vim.fn.system(chmod_cmd)
    else
      os.execute("mkdir " .. install_dir)
      coursier_exe = "cs"
    end
    local install_cmd = string.format("%s bootstrap --java-opt -Xss4m --java-opt -Xms100m --java-opt -Dmetals.client=coc.nvim org.scalameta:metals_2.12:latest.release -r bintray:scalacenter/releases -r sonatype:snapshots -o %s -f", coursier_exe, metals_bin)
    vim.fn.system(install_cmd)
  end
  function X.info()
    return {
      is_installed = util.path.exists(metals_bin);
      install_dir = install_dir;
      cmd = { metals_bin };
    }
  end
  function X.configure(config)
    local install_info = X.info()
    if install_info.is_installed then
      config.cmd = install_info.cmd
    end
  end
  return X
end

local installer = make_installer()

configs[server_name] = {
  default_config = {
    cmd = {bin_name};
    filetypes = {"scala"};
    root_dir = util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml");
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    vscode = "scalameta.metals";
    package_json = "https://raw.githubusercontent.com/scalameta/metals-vscode/master/package.json";
    description = [[
https://scalameta.org/metals/

Scala language server with rich IDE features.
`metals` can be installed via `:LspInstall metals`.
]];
    default_config = {
      root_dir = [[util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml")]];
    };
  };
};

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
