--- Installer module for gthr binary
local M = {}

--- Target gthr version - CHANGE THIS WHEN UPDATING GTHR VERSION
M.GTHR_VERSION = 'v0.2.0'

--- Get the installation directory for gthr binary
--- @return string Installation directory path
function M.get_install_dir()
  local data_dir = vim.fn.stdpath('data')
  return data_dir .. '/gthr-nvim'
end

--- Get the path where gthr binary should be installed
--- @return string Binary path
function M.get_binary_path()
  local install_dir = M.get_install_dir()
  if vim.fn.has('win32') == 1 then
    return install_dir .. '/gthr.exe'
  else
    return install_dir .. '/gthr'
  end
end

--- Detect current platform and return the appropriate asset name
--- @param version string Version tag (e.g., 'v0.2.0')
--- @return string|nil asset_name Asset filename or nil if platform not supported
--- @return string|nil error Error message if platform not supported
function M.detect_platform(version)
  local os_name = vim.loop.os_uname().sysname
  local arch = vim.loop.os_uname().machine

  -- Normalize architecture names
  if arch == 'arm64' then
    arch = 'aarch64'
  elseif arch == 'AMD64' or arch == 'x86_64' then
    arch = 'x86_64'
  end

  local asset_name

  if os_name == 'Darwin' then
    -- macOS
    if arch == 'aarch64' then
      asset_name = 'gthr-aarch64-apple-darwin.tar.gz'
    elseif arch == 'x86_64' then
      asset_name = 'gthr-x86_64-apple-darwin.tar.gz'
    else
      return nil, 'Unsupported macOS architecture: ' .. arch
    end
  elseif os_name == 'Linux' then
    -- Linux - prefer musl for better compatibility
    if arch == 'x86_64' then
      asset_name = 'gthr-x86_64-unknown-linux-musl.tar.gz'
    else
      return nil, 'Unsupported Linux architecture: ' .. arch
    end
  elseif os_name:match('Windows') then
    -- Windows
    if arch == 'x86_64' then
      asset_name = 'gthr-x86_64-pc-windows-msvc.exe.zip'
    else
      return nil, 'Unsupported Windows architecture: ' .. arch
    end
  else
    return nil, 'Unsupported operating system: ' .. os_name
  end

  return asset_name, nil
end

--- Get version of a gthr binary
--- @param cmd string Path to gthr binary
--- @return string|nil version Version string or nil if failed
function M.get_version(cmd)
  local output = vim.fn.system(cmd .. ' --version')
  if vim.v.shell_error ~= 0 then
    return nil
  end

  -- Parse version from output like "gthr 0.2.0"
  local version = output:match('gthr%s+([%d%.]+)')
  if version then
    return 'v' .. version
  end

  return nil
end

--- Check if gthr binary is available with correct version
--- @return boolean available Whether gthr with correct version is available
--- @return string|nil path Path to gthr binary
function M.is_available()
  -- First check if we have installed it ourselves
  local binary_path = M.get_binary_path()
  if vim.fn.executable(binary_path) == 1 then
    local version = M.get_version(binary_path)
    if version == M.GTHR_VERSION then
      return true, binary_path
    end
  end

  -- Check if gthr is in PATH with correct version
  if vim.fn.executable('gthr') == 1 then
    local version = M.get_version('gthr')
    if version == M.GTHR_VERSION then
      return true, 'gthr'
    end
  end

  return false, nil
end

--- Download and install gthr binary
--- @param version? string Version to install (default: M.GTHR_VERSION)
--- @param callback? function Callback function(success, message)
function M.install(version, callback)
  version = version or M.GTHR_VERSION
  callback = callback or function() end

  -- Detect platform
  local asset_name, err = M.detect_platform(version)
  if not asset_name then
    callback(false, err)
    return
  end

  local install_dir = M.get_install_dir()
  local binary_path = M.get_binary_path()
  local download_url = string.format(
    'https://github.com/Adarsh-Roy/gthr/releases/download/%s/%s',
    version,
    asset_name
  )

  vim.notify('Installing gthr ' .. version .. '...', vim.log.levels.INFO)

  -- Create installation directory
  vim.fn.mkdir(install_dir, 'p')

  -- Download and extract in background
  local temp_file = install_dir .. '/' .. asset_name
  local is_windows = vim.fn.has('win32') == 1
  local extract_cmd

  if asset_name:match('%.zip$') then
    -- Windows zip file
    extract_cmd = string.format('unzip -o "%s" -d "%s" && mv "%s/gthr.exe" "%s"',
      temp_file, install_dir, install_dir, binary_path)
  else
    -- Unix tar.gz file - extract, find gthr binary (with or without platform suffix), move it to correct location
    extract_cmd = string.format(
      'tar -xzf "%s" -C "%s" && find "%s" -name "gthr*" -type f -perm +111 -exec mv {} "%s" \\;',
      temp_file,
      install_dir,
      install_dir,
      binary_path
    )
  end

  local download_cmd = string.format(
    'curl -fsSL "%s" -o "%s" && %s && chmod +x "%s" && rm "%s"',
    download_url,
    temp_file,
    extract_cmd,
    binary_path,
    temp_file
  )

  -- Execute download and installation
  vim.fn.jobstart(download_cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.schedule(function()
          vim.notify('gthr installed successfully at ' .. binary_path, vim.log.levels.INFO)
          callback(true, binary_path)
        end)
      else
        vim.schedule(function()
          vim.notify('Failed to install gthr (exit code: ' .. exit_code .. ')', vim.log.levels.ERROR)
          callback(false, 'Installation failed')
        end)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.schedule(function()
          for _, line in ipairs(data) do
            if line ~= '' then
              vim.notify('gthr install: ' .. line, vim.log.levels.WARN)
            end
          end
        end)
      end
    end,
  })
end

--- Ensure gthr is available with correct version, install if needed
--- @param callback function Callback function(cmd) called with gthr command path
function M.ensure_available(callback)
  local available, path = M.is_available()

  if available then
    callback(path)
    return
  end

  -- Not available or wrong version, install it
  vim.notify('gthr ' .. M.GTHR_VERSION .. ' not found, installing...', vim.log.levels.INFO)
  M.install(M.GTHR_VERSION, function(success, result)
    if success then
      callback(result)
    else
      vim.notify('Failed to install gthr: ' .. (result or 'unknown error'), vim.log.levels.ERROR)
    end
  end)
end

return M
