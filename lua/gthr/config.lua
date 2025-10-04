--- Configuration module for gthr.nvim
--- @class GthrConfig
--- @field window GthrWindowConfig
--- @field cmd string|nil
--- @field auto_install boolean
--- @field gthr GthrOptions

--- @class GthrWindowConfig
--- @field width number
--- @field height number
--- @field border string

--- @class GthrOptions
--- @field root? string
--- @field respect_gitignore? boolean
--- @field show_hidden? boolean
--- @field max_file_size? number

local M = {}

--- Default configuration
--- @type GthrConfig
M.defaults = {
  window = {
    width = 0.8,
    height = 0.7,
    border = 'rounded',
  },
  cmd = nil, -- Auto-detect or use installed binary
  auto_install = true, -- Automatically install gthr if not found
  gthr = {
    root = nil,
    respect_gitignore = true,
    show_hidden = false,
    max_file_size = 2097152, -- 2MB
  },
}

--- Current configuration
--- @type GthrConfig
M.options = vim.deepcopy(M.defaults)

--- Setup configuration
--- @param opts? GthrConfig
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
end

--- Get current configuration
--- @return GthrConfig
function M.get()
  return M.options
end

return M
