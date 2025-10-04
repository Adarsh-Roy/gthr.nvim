--- Tests for gthr.config module

local T = MiniTest.new_set()

T['config'] = MiniTest.new_set()

T['config']['has defaults'] = function()
  local config = require('gthr.config')

  MiniTest.expect.equality(config.defaults.window.width, 0.8)
  MiniTest.expect.equality(config.defaults.window.height, 0.7)
  MiniTest.expect.equality(config.defaults.window.border, 'rounded')
  MiniTest.expect.equality(config.defaults.auto_install, true)
  MiniTest.expect.equality(config.defaults.version, 'v0.2.0')
  MiniTest.expect.equality(config.defaults.clipboard, '+')
end

T['config']['setup merges options'] = function()
  local config = require('gthr.config')

  config.setup({
    window = { width = 0.9 },
    auto_install = false,
  })

  local opts = config.get()
  MiniTest.expect.equality(opts.window.width, 0.9)
  MiniTest.expect.equality(opts.window.height, 0.7) -- default preserved
  MiniTest.expect.equality(opts.auto_install, false)
end

return T
