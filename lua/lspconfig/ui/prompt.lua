local util = require "lspconfig.util"

local M = {}

M.directory_picker = function(parent_dir)
  return vim.fn.input("Root Directory: ", parent_dir, "dir")
end

M.root_directory_prompt = function(filepath, border)
  local filename = vim.fn.fnamemodify(filepath, ":t")
  local parent_dir = util.path.dirname(filepath)

  local bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(bufnr, true, {
    relative = "win",
    style = "minimal",
    row = vim.o.lines,
    col = 0,
    width = vim.o.columns,
    height = 8,
    border = border,
  })
  vim.cmd(string.format("autocmd BufLeave <buffer=%d> ++once lua vim.api.nvim_win_close(%s, true)", bufnr, winnr))

  local no_root_detected_message = string.format(" No root pattern matched for %s", filename)
  local parent_dir_option = string.format(" p -> Set parent directory as project root %s", parent_dir)
  local interactive_option = string.format " c -> Interactively choose the project root"
  local ignore_file_option = string.format " i -> Ignore this file."

  vim.api.nvim_buf_set_lines(
    bufnr,
    0,
    -1,
    true,
    { "", no_root_detected_message, "", parent_dir_option, interactive_option, ignore_file_option }
  )
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.cmd [[redraw]]

  local choices = {
    ["p"] = function()
      return parent_dir
    end,
    ["c"] = M.directory_picker,
    ["i"] = function()
      return nil
    end,
  }

  local user_choice
  local root_directory

  while true do
    local ok, user_input = pcall(vim.fn.getchar)
    -- handle escape
    if not ok or user_input == 27 then
      break
    end
    if type(user_input) == "number" then
      user_choice = string.char(user_input)
    end
    if choices[user_choice] then
      root_directory = choices[user_choice](filepath)
      break
    end
  end
  vim.api.nvim_win_close(winnr, true)
  return root_directory
end

return M
