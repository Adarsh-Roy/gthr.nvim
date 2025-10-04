--- Plugin definition for gthr.nvim
--- This file is automatically sourced by Neovim

-- Prevent loading twice
if vim.g.loaded_gthr then
  return
end
vim.g.loaded_gthr = 1

-- Setup autocmd for gthr terminal buffers to reduce escape delay
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gthr',
  callback = function()
    -- Reduce timeout for escape sequences in terminal
    vim.opt_local.timeoutlen = 10
  end,
})

-- Create user commands
vim.api.nvim_create_user_command('Gthr', function()
  require('gthr').open()
end, {
  desc = 'Open gthr in interactive mode'
})

vim.api.nvim_create_user_command('GthrBuffersInteractive', function()
  require('gthr').open_with_buffers()
end, {
  desc = 'Open gthr with all open buffers pre-included'
})

vim.api.nvim_create_user_command('GthrBuffersDirect', function()
  require('gthr').gather()
end, {
  desc = 'Gather context from all open buffers (direct mode)'
})
