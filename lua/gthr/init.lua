--- Main module for gthr.nvim
local config = require('gthr.config')
local buffers = require('gthr.buffers')
local floating = require('gthr.floating')
local installer = require('gthr.installer')

local M = {}

--- Get the gthr command path, ensuring it's available
--- @param callback function Callback function(cmd) called with gthr command
local function get_gthr_cmd(callback)
  local cfg = config.get()

  -- If user specified a custom command, use it directly
  if cfg.cmd then
    callback(cfg.cmd)
    return
  end

  -- Check if auto-install is enabled
  if not cfg.auto_install then
    -- Try to use gthr from PATH
    if vim.fn.executable('gthr') == 1 then
      callback('gthr')
    else
      vim.notify('gthr not found. Please install it or enable auto_install', vim.log.levels.ERROR)
    end
    return
  end

  -- Auto-install if needed
  installer.ensure_available(callback)
end

--- Setup gthr.nvim with user configuration
--- @param opts? GthrConfig User configuration options
function M.setup(opts)
  config.setup(opts)
end

--- Open gthr in interactive mode in a floating window
function M.open()
  get_gthr_cmd(function(gthr_cmd)
    local cmd = gthr_cmd .. ' interactive'
    floating.open_terminal(cmd)
  end)
end

--- Open gthr in interactive mode with all open buffers pre-included
function M.open_with_buffers()
  local paths = buffers.get_file_paths(true) -- Use relative paths

  if #paths == 0 then
    vim.notify('No file buffers open', vim.log.levels.WARN)
    return
  end

  get_gthr_cmd(function(gthr_cmd)
    -- Build command: gthr -i path1 -i path2 ... interactive
    local cmd = gthr_cmd
    cmd = buffers.build_include_args(paths, cmd)
    cmd = cmd .. ' interactive'

    floating.open_terminal(cmd)
  end)
end

--- Gather context from all open buffers using gthr direct mode
--- Output is automatically copied to clipboard by gthr itself
function M.gather()
  local paths = buffers.get_file_paths(true) -- Use relative paths

  if #paths == 0 then
    vim.notify('No file buffers open', vim.log.levels.WARN)
    return
  end

  get_gthr_cmd(function(gthr_cmd)
    -- Build command: gthr -i path1 -i path2 ... direct
    local cmd = gthr_cmd
    cmd = buffers.build_include_args(paths, cmd)
    cmd = cmd .. ' direct'

    -- Execute command - gthr handles clipboard copying itself
    vim.fn.jobstart(cmd, {
      on_exit = function(_, exit_code)
        vim.schedule(function()
          if exit_code == 0 then
            vim.notify('Context gathered from ' .. #paths .. ' file(s)', vim.log.levels.INFO)
          else
            vim.notify('gthr failed with exit code ' .. exit_code, vim.log.levels.ERROR)
          end
        end)
      end,
    })
  end)
end

return M
