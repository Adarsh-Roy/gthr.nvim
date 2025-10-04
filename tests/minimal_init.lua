--- Minimal init file for running tests with mini.test

-- Add current directory to runtimepath
vim.cmd('set rtp+=.')

-- Clone mini.nvim if it doesn't exist
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim"')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim')
  vim.cmd('echo "Installed mini.nvim"')
else
  vim.cmd('packadd mini.nvim')
end

-- Setup mini.test
require('mini.test').setup()
