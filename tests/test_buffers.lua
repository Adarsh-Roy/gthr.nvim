--- Tests for gthr.buffers module

local T = MiniTest.new_set()

T['buffers'] = MiniTest.new_set()

T['buffers']['build_include_args with no paths'] = function()
  local buffers = require('gthr.buffers')
  local result = buffers.build_include_args({}, 'gthr')

  MiniTest.expect.equality(result, 'gthr')
end

T['buffers']['build_include_args with single path'] = function()
  local buffers = require('gthr.buffers')
  local result = buffers.build_include_args({'/path/to/file.txt'}, 'gthr')

  -- Should contain the command and -i flag
  MiniTest.expect.equality(result:match('gthr') ~= nil, true)
  MiniTest.expect.equality(result:match('-i') ~= nil, true)
  MiniTest.expect.equality(result:match('file.txt') ~= nil, true)
end

T['buffers']['build_include_args with multiple paths'] = function()
  local buffers = require('gthr.buffers')
  local paths = {'/path/to/file1.txt', '/path/to/file2.txt'}
  local result = buffers.build_include_args(paths, 'gthr')

  -- Should contain both files
  MiniTest.expect.equality(result:match('file1.txt') ~= nil, true)
  MiniTest.expect.equality(result:match('file2.txt') ~= nil, true)

  -- Should have two -i flags
  local _, count = result:gsub('-i', '')
  MiniTest.expect.equality(count, 2)
end

return T
