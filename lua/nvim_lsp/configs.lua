local util = require 'nvim_lsp/util'
local api, validate, lsp = vim.api, vim.validate, vim.lsp
local tbl_extend = vim.tbl_extend

local configs = {}

function configs.__newindex(t, config_name, config_def)
  validate {
    name = {config_name, 's'};
    default_config = {config_def.default_config, 't'};
    on_new_config = {config_def.on_new_config, 'f', true};
    on_attach = {config_def.on_attach, 'f', true};
    commands = {config_def.commands, 't', true};
  }
  if config_def.commands then
    for k, v in pairs(config_def.commands) do
      validate {
        ['command.name'] = {k, 's'};
        ['command.fn'] = {v[1], 'f'};
      }
    end
  else
    config_def.commands = {}
  end

  local M = {}

  local default_config = tbl_extend("keep", config_def.default_config, util.default_config)

  -- Force this part.
  default_config.name = config_name

  -- The config here is the one which will be instantiated for the new server,
  -- which is why this is a function, so that it can refer to the settings
  -- object on the server.
  local function add_callbacks(config)
    config.callbacks["window/logMessage"] = function(err, method, params, client_id)
      if params and params.type <= config.log_level then
        -- TODO(ashkan) remove this after things have settled.
        assert(lsp.callbacks, "Update to Nvim HEAD. This is an incompatible interface.")
        assert(lsp.callbacks["window/logMessage"], "Callback for window/logMessage notification is not defined")
        lsp.callbacks["window/logMessage"](err, method, params, client_id)
      end
    end

    config.callbacks["window/showMessage"] = function(err, method, params, client_id)
      if params and params.type <= config.message_level then
        -- TODO(ashkan) remove this after things have settled.
        assert(lsp.callbacks and lsp.callbacks[method], "Update to Nvim HEAD. This is an incompatible interface.")
        assert(lsp.callbacks["window/showMessage"], "Callback for window/showMessage notification is not defined")
        lsp.callbacks["window/showMessage"](err, method, params, client_id)
      end
    end

    config.callbacks["workspace/configuration"] = function(err, method, params, client_id)
      if err then error(tostring(err)) end
      if not params.items then
        return {}
      end

      local result = {}
      for _, item in ipairs(params.items) do
        if item.section then
          local value = util.lookup_section(config.settings, item.section) or vim.NIL
          -- For empty sections with no explicit '' key, return settings as is
          if value == vim.NIL and item.section == '' then
            value = config.settings or vim.NIL
          end
          table.insert(result, value)
        end
      end
      return result
    end
  end

  function M.setup(config)
    validate {
      root_dir = {config.root_dir, 'f', default_config.root_dir ~= nil};
      filetypes = {config.filetype, 't', true};
      on_new_config = {config.on_new_config, 'f', true};
      on_attach = {config.on_attach, 'f', true};
      commands = {config.commands, 't', true};
    }
    if config.commands then
      for k, v in pairs(config.commands) do
        validate {
          ['command.name'] = {k, 's'};
          ['command.fn'] = {v[1], 'f'};
        }
      end
    end

    config = tbl_extend("keep", config, default_config)

    local trigger
    if config.filetypes then
      trigger = "FileType "..table.concat(config.filetypes, ',')
    else
      trigger = "BufReadPost *"
    end
    api.nvim_command(string.format(
        "autocmd %s lua require'nvim_lsp'[%q].manager.try_add()"
        , trigger
        , config.name
        ))

    local get_root_dir = config.root_dir

    -- In the case of a reload, close existing things.
    if M.manager then
      for _, client in ipairs(M.manager.clients()) do
        client.stop(true)
      end
      M.manager = nil
    end

    local make_config = function(_root_dir)
      local new_config = util.tbl_deep_extend("keep", vim.empty_dict(), config)
      new_config = util.tbl_deep_extend('keep', new_config, default_config)
      new_config.capabilities = new_config.capabilities or lsp.protocol.make_client_capabilities()
      new_config.capabilities = util.tbl_deep_extend('keep', new_config.capabilities, {
        workspace = {
          configuration = true;
        }
      })

      add_callbacks(new_config)
      new_config.root_dir = _root_dir
      if config_def.on_new_config then
        pcall(config_def.on_new_config, new_config, _root_dir)
      end
      if config.on_new_config then
        pcall(config.on_new_config, new_config, _root_dir)
      end

      new_config.on_init = util.add_hook_after(new_config.on_init, function(client, _result)
        function client.workspace_did_change_configuration(settings)
          if not settings then return end
          if vim.tbl_isempty(settings) then
            settings = {[vim.type_idx]=vim.types.dictionary}
          end
          return client.notify('workspace/didChangeConfiguration', {
            settings = settings;
          })
        end
        if not vim.tbl_isempty(new_config.settings) then
          client.workspace_did_change_configuration(new_config.settings)
        end
      end)

      -- Save the old _on_attach so that we can reference it via the BufEnter.
      new_config._on_attach = new_config.on_attach
      new_config.on_attach = vim.schedule_wrap(function(client, bufnr)
        if bufnr == api.nvim_get_current_buf() then
          M._setup_buffer(client.id)
        else
          api.nvim_command(string.format(
              "autocmd BufEnter <buffer=%d> ++once lua require'nvim_lsp'[%q]._setup_buffer(%d)"
              , bufnr
              , config_name
              , client.id
              ))
        end
      end)

      return new_config
    end

    local manager = util.server_per_root_dir_manager(function(_root_dir)
      return make_config(_root_dir)
    end)

    function manager.try_add()
      if vim.bo.buftype == 'nofile' then
        return
      end
      local root_dir = get_root_dir(api.nvim_buf_get_name(0), api.nvim_get_current_buf())
      local id = manager.add(root_dir)
      if id then
        lsp.buf_attach_client(0, id)
      end
    end

    M.manager = manager
    M.make_config = make_config
  end

  function M._setup_buffer(client_id)
    local client = lsp.get_client_by_id(client_id)
    if client.config._on_attach then
      client.config._on_attach(client)
    end
    if client.config.commands and not vim.tbl_isempty(client.config.commands) then
      M.commands = util.tbl_deep_extend("force", M.commands, client.config.commands)
    end
    if not M.commands_created and not vim.tbl_isempty(M.commands) then
      -- Create the module commands
      util.create_module_commands(config_name, M.commands)
      M.commands_created = true
    end
  end

  M.commands_created = false
  M.commands = config_def.commands
  M.name = config_name
  M.document_config = config_def

  rawset(t, config_name, M)

  return M
end

return setmetatable({}, configs)
-- vim:et ts=2 sw=2
