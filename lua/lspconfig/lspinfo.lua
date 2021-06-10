local configs = require 'lspconfig/configs'
local lspui = require 'lspconfig/_lspui'

return function ()
  -- These options need to be cached before switching to the floating
  -- buffer.
  local buf_clients = vim.lsp.buf_get_clients()
  local clients = vim.lsp.get_active_clients()
  local buffer_filetype = vim.bo.filetype
  local buffer_dir = vim.fn.expand('%:p:h')

  local win_info = lspui.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id

  local buf_lines = {}

  local buf_client_names = {}
  for _, client in pairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  local header = {
    "Configured servers: "..table.concat(vim.tbl_keys(configs), ', '),
    "Neovim logs at: "..(vim.lsp.get_log_path()),
    "",
    tostring(#vim.tbl_keys(buf_clients)).." client(s) attached to this buffer: "..table.concat(buf_client_names, ', '),
  }
  vim.list_extend(buf_lines, header)

  local function trim_whitespace(cmd)
    local trimmed_cmd = {}
    for _, str in pairs(cmd) do
      table.insert(trimmed_cmd, str:match'^%s*(.*)')
    end
    return trimmed_cmd
  end

  local function remove_newlines(cmd)
    cmd = trim_whitespace(cmd)
    cmd = table.concat(cmd, ' ')
    cmd = vim.split(cmd, '\n')
    cmd = trim_whitespace(cmd)
    cmd = table.concat(cmd, ' ')
    return cmd
  end

  local indent = "  "
  local function make_client_info(client)
    local server_specific_info = ""
    if client.config.lspinfo then
      server_specific_info = client.config.lspinfo(client.config)
    end
    return {
      "",
      indent.."Client: "..client.name.." (id "..tostring(client.id)..")",
      indent.."\troot:      "..client.workspaceFolders[1].name,
      indent.."\tfiletypes: "..table.concat(client.config.filetypes or {}, ', '),
      indent.."\tcmd:       "..remove_newlines(client.config.cmd),
      indent.."\t"..server_specific_info,
      ""
    }
  end

  for _, client in pairs(buf_clients) do
     local client_info = make_client_info(client)
     vim.list_extend(buf_lines, client_info)
  end

  local active_section_header = {
    "",
    tostring(#clients).." active client(s): ",
  }
  vim.list_extend(buf_lines, active_section_header)
  for _, client in pairs(clients) do
     local client_info = make_client_info(client)
     vim.list_extend(buf_lines, client_info)
  end
  local matching_config_header = {
    "",
    "Clients that match the filetype "..buffer_filetype..":",
  }
  local cmd_not_found_msg = "False. Please check your path and ensure the server is installed"
  vim.list_extend(buf_lines, matching_config_header)
  for _, config in pairs(configs) do
    local cmd_is_executable, cmd
    if config.cmd then
      cmd = remove_newlines(config.cmd)
      if vim.fn.executable(config.cmd[1]) == 1 then
        cmd_is_executable = "True"
      else
        cmd_is_executable = cmd_not_found_msg
      end
    else
      cmd = "cmd not defined"
      cmd_is_executable = cmd
    end
    print(config.cmd, vim.inspect(config.autostart))
    if config.filetypes then
      for _, filetype_match in pairs(config.filetypes) do
        if buffer_filetype == filetype_match then
          local autostart_status = "True"
          if config.autostart == false then
            autostart_status = "Disabled"
          end
          -- print("autostart", config.autostart)
          local matching_config_info = {
            indent.."",
            indent.."Config: "..config.name,
            indent.."\tcmd:               "..cmd,
            indent.."\tcmd is executable: ".. cmd_is_executable,
            indent.."\tidentified root:   "..(config.get_root_dir(buffer_dir) or "None"),
            indent.."\tautostart:         "..(autostart_status),
            indent.."\tcustom handlers:   "..table.concat(vim.tbl_keys(config.handlers), ", "),
          }
         vim.list_extend(buf_lines, matching_config_info)
        end
      end
    else
        local matching_config_info = {
          "",
          "Config: "..config.name,
          "\tfiletype: ".."No filetypes defined, please define filetypes in setup().",
        }
       vim.list_extend(buf_lines, matching_config_info)
    end
  end
  buf_lines = vim.lsp.util._trim(buf_lines, {})
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines )
  vim.api.nvim_buf_set_option(bufnr,'modifiable',false)
  vim.api.nvim_buf_set_option(bufnr,'filetype','lspinfo')
  local configs_pattern = '\\%(' .. table.concat(vim.tbl_keys(configs), '\\|') .. '\\)'
  vim.cmd('syntax match Title /\\%(Client\\|Config\\):.*\\zs' .. configs_pattern .. '/')
  vim.cmd('syntax match Identifier /filetypes:.*\\zs\\<' .. buffer_filetype .. '\\>/')
  vim.fn.matchadd("Error",
    "No filetypes defined, please define filetypes in setup().\\|"..
    "cmd not defined\\|" ..
    cmd_not_found_msg)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>bd<CR>', { noremap = true})
  vim.lsp.util.close_preview_autocmd({"BufHidden", "BufLeave"}, win_id)
end;
