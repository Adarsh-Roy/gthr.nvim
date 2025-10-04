--- Floating window management for gthr.nvim
local config = require('gthr.config')

local M = {}

--- Create a centered floating window
--- @return integer bufnr Buffer number
--- @return integer winid Window ID
function M.create_window()
  local cfg = config.get()

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * cfg.window.width)
  local height = math.floor(vim.o.lines * cfg.window.height)

  -- Calculate position to center the window
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create scratch buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.bo[bufnr].bufhidden = 'wipe'

  -- Window configuration
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = cfg.window.border,
  }

  -- Open floating window
  local winid = vim.api.nvim_open_win(bufnr, true, opts)

  return bufnr, winid
end

--- Open a terminal in a floating window with auto-close on exit
--- @param cmd string Command to run in terminal
--- @return integer bufnr Buffer number
--- @return integer winid Window ID
function M.open_terminal(cmd)
  local bufnr, winid = M.create_window()

  -- Start terminal with on_exit callback to auto-close window
  vim.fn.termopen(cmd, {
    on_exit = function(job_id, exit_code, event)
      -- Schedule the window close to avoid issues during callback
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, true)
        end
      end)
    end
  })

  -- Enter insert mode in terminal
  vim.cmd('startinsert')

  return bufnr, winid
end

return M
