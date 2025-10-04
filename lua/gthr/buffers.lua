--- Buffer utilities for gthr.nvim
local M = {}

--- Get list of all valid file buffer paths
--- Filters out special buffers (help, terminal, quickfix, etc.)
--- @param relative? boolean Return relative paths instead of absolute (default: true)
--- @return string[] List of file paths
function M.get_file_paths(relative)
  if relative == nil then relative = true end

  local buffers = vim.api.nvim_list_bufs()
  local paths = {}
  local cwd = vim.fn.getcwd()

  for _, buf in ipairs(buffers) do
    -- Check if buffer is loaded, listed, and is a normal file buffer
    if vim.api.nvim_buf_is_loaded(buf)
       and vim.bo[buf].buflisted
       and vim.bo[buf].buftype == '' then
      local path = vim.api.nvim_buf_get_name(buf)
      -- Only include paths that are non-empty and readable files
      if path ~= '' and vim.fn.filereadable(path) == 1 then
        -- Convert to relative path if requested
        if relative then
          path = vim.fn.fnamemodify(path, ':.')
        end
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
