--- Buffer utilities for gthr.nvim
local M = {}

--- Get list of all valid file buffer paths
--- Filters out special buffers (help, terminal, quickfix, etc.)
--- @return string[] List of absolute file paths
function M.get_file_paths()
  local buffers = vim.api.nvim_list_bufs()
  local paths = {}

  for _, buf in ipairs(buffers) do
    -- Check if buffer is loaded, listed, and is a normal file buffer
    if vim.api.nvim_buf_is_loaded(buf)
       and vim.bo[buf].buflisted
       and vim.bo[buf].buftype == '' then
      local path = vim.api.nvim_buf_get_name(buf)
      -- Only include paths that are non-empty and readable files
      if path ~= '' and vim.fn.filereadable(path) == 1 then
        table.insert(paths, path)
      end
    end
  end

  return paths
end

--- Build gthr command arguments for including buffer paths
--- @param paths string[] List of file paths
--- @param base_cmd? string Base command to append to (default: "")
--- @return string Command with -i flags for each path
function M.build_include_args(paths, base_cmd)
  local cmd = base_cmd or ""

  for _, path in ipairs(paths) do
    -- Escape path for shell
    local escaped_path = vim.fn.shellescape(path)
    cmd = cmd .. " -i " .. escaped_path
  end

  return cmd
end

return M
