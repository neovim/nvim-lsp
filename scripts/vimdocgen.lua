local docgen = require('babelfish')

local docs = {}

docs.generate = function()
  local metadata = {
    input_file = "./README.md",
    output_file = "./doc/lspconfig.txt",
    project_name = "lspconfig",
    header_aliases = {
      ["Automatically launching language servers"] = {"root-detection", "root-detection"},
      ["Enabling additional language servers"] = {"adding-servers", "adding-servers"},
      ["Keybindings and completion"] = {"Keybindings", "keybindings"},
    }
  }
  docgen.generate_readme(metadata)
end

docs.generate()

return docs
