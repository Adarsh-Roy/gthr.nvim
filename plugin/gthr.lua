--- Plugin definition for gthr.nvim
--- This file is automatically sourced by Neovim

-- Prevent loading twice
if vim.g.loaded_gthr then
  return
end
vim.g.loaded_gthr = 1

-- Create user commands
vim.api.nvim_create_user_command('Gthr', function()
  require('gthr').open()
end, {
  desc = 'Open gthr in interactive mode'
})

vim.api.nvim_create_user_command('GthrBuffers', function()
  require('gthr').open_with_buffers()
end, {
  desc = 'Open gthr with all open buffers pre-included'
})

vim.api.nvim_create_user_command('GthrGather', function()
  require('gthr').gather()
end, {
  desc = 'Gather context from all open buffers (direct mode)'
})
