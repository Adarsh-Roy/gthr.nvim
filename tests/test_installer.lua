--- Tests for gthr.installer module

local T = MiniTest.new_set()

T['installer'] = MiniTest.new_set()

T['installer']['detect_platform returns asset name'] = function()
  local installer = require('gthr.installer')
  local asset_name, err = installer.detect_platform('v0.2.0')

  -- Should return a valid asset name without error
  MiniTest.expect.equality(err, nil)
  MiniTest.expect.equality(asset_name ~= nil, true)

  -- Asset name should contain gthr
  MiniTest.expect.equality(asset_name:match('gthr') ~= nil, true)
end

T['installer']['get_install_dir returns path'] = function()
  local installer = require('gthr.installer')
  local dir = installer.get_install_dir()

  MiniTest.expect.equality(dir ~= nil, true)
  MiniTest.expect.equality(dir:match('gthr%-nvim') ~= nil, true)
end

T['installer']['get_binary_path returns executable path'] = function()
  local installer = require('gthr.installer')
  local path = installer.get_binary_path()

  MiniTest.expect.equality(path ~= nil, true)
  MiniTest.expect.equality(path:match('gthr') ~= nil, true)
end

return T
