# gthr.nvim

Neovim integration for [gthr](https://github.com/Adarsh-Roy/gthr) - a CLI tool for gathering text context from directories with an interactive fuzzy finder.

> ⚠️ **Note:** This plugin is currently in **Alpha**.  

**Current gthr version:** v0.2.0

## Features

- **Interactive Mode** - Opens gthr's TUI in a floating window
- **Buffer Integration** - Pre-include all open buffers in gthr
- **Direct Mode** - Gather context from all open buffers directly to clipboard
- **Auto-Install** - Automatically downloads the correct gthr version if not found

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'Adarsh-Roy/gthr.nvim',
  version = 'v0.1.0',
  cmd = { 'Gthr', 'GthrBuffersInteractive', 'GthrBuffersDirect' },
  keys = {
    { '<leader>Go', '<cmd>Gthr<cr>', desc = 'Open gthr in floating window' },
    { '<leader>Gbi', '<cmd>GthrBuffersInteractive<cr>', desc = 'Open gthr floating window with all buffers pre-included' },
    { '<leader>Gbd', '<cmd>GthrBuffersDirect<cr>', desc = 'Copy context for all open buffers directly' },
  },
  opts = {},
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'Adarsh-Roy/gthr.nvim',
  tag = 'v0.1.0', -- Pin to specific version
  config = function()
    require('gthr').setup({})
  end
}
```

## Commands

| Command | Description |
|---------|-------------|
| `:Gthr` | Open gthr in interactive mode |
| `:GthrBuffersInteractive` | Open gthr with all open buffers pre-included |
| `:GthrBuffersDirect` | Gather context from all open buffers to clipboard |

## Configuration

Default configuration:

```lua
require('gthr').setup({
  window = {
    width = 0.8,      -- 80% of editor width
    height = 0.7,     -- 70% of editor height
    border = 'rounded', -- 'single', 'double', 'rounded', 'solid', 'shadow'
  },
  cmd = nil,          -- Auto-detect gthr (or specify custom path)
  auto_install = true, -- Automatically install gthr if not found
  clipboard = '+',    -- System clipboard register
})
```

### Custom gthr Path

If you have gthr installed in a custom location, you can specify it in `opts`:

```lua
{
  'Adarsh-Roy/gthr.nvim',
  opts = {
    cmd = '/path/to/gthr',
    auto_install = false,
  },
}
```

Or via `setup()`:

```lua
require('gthr').setup({
  cmd = '/path/to/gthr',
  auto_install = false,
})
```

## Lua API

```lua
-- Open gthr interactively
require('gthr').open()

-- Open gthr with all open buffers
require('gthr').open_with_buffers()

-- Gather context to clipboard
require('gthr').gather()
```

## Requirements

- Neovim >= 0.8.0
- `curl` (for auto-installation)
- `tar` (for extracting binaries on Unix)

The plugin will automatically download gthr v0.2.0 on first use if not found.

## Supported Platforms

Auto-installation works on:
- macOS (Apple Silicon & Intel)
- Linux (x86_64)
- Windows (x86_64)

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Links

- [gthr CLI](https://github.com/Adarsh-Roy/gthr) - The underlying CLI tool
- [Report Issues](https://github.com/Adarsh-Roy/gthr.nvim/issues)
