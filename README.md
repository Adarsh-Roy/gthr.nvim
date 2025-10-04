# gthr.nvim

A Neovim plugin that integrates the [gthr](https://github.com/Adarsh-Roy/gthr) CLI tool into your editor workflow, providing seamless context gathering capabilities.

## Features

- **Interactive Mode**: Open gthr's fuzzy finder TUI in a floating window
- **Buffer Integration**: Pre-include all open buffers when launching gthr
- **Direct Mode**: Gather context from all open buffers directly to clipboard
- **Auto-Installation**: Automatically downloads and installs gthr if not found
- **Zero Dependencies**: No external plugin dependencies (except mini.nvim for testing)
- **Lazy.nvim Compatible**: Follows best practices for lazy loading

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'Adarsh-Roy/gthr.nvim',
  opts = {}, -- See configuration options below
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'Adarsh-Roy/gthr.nvim',
  config = function()
    require('gthr').setup({})
  end
}
```

## Usage

### Commands

- `:Gthr` - Open gthr in interactive mode in a floating window
- `:GthrBuffers` - Open gthr with all currently open buffers pre-included
- `:GthrGather` - Gather context from all open buffers to clipboard (direct mode)

### Lua API

```lua
-- Open gthr interactively
require('gthr').open()

-- Open gthr with all open buffers
require('gthr').open_with_buffers()

-- Gather context to clipboard
require('gthr').gather()
```

### Key Mappings (Example)

```lua
vim.keymap.set('n', '<leader>go', '<cmd>Gthr<cr>', { desc = 'Open gthr' })
vim.keymap.set('n', '<leader>gb', '<cmd>GthrBuffers<cr>', { desc = 'Gthr with buffers' })
vim.keymap.set('n', '<leader>gg', '<cmd>GthrGather<cr>', { desc = 'Gather context' })
```

## Configuration

Default configuration:

```lua
require('gthr').setup({
  -- Window appearance
  window = {
    width = 0.8,   -- 80% of editor width
    height = 0.7,  -- 70% of editor height
    border = 'rounded', -- 'single', 'double', 'rounded', 'solid', 'shadow'
  },

  -- gthr binary settings
  cmd = nil,          -- Auto-detect gthr (or specify custom path)
  auto_install = true, -- Automatically install gthr if not found
  version = 'v0.2.0',  -- Version to install

  -- gthr default options
  gthr = {
    root = nil,              -- Use current working directory
    respect_gitignore = true,
    show_hidden = false,
    max_file_size = 2097152, -- 2MB
  },

  -- Clipboard register
  clipboard = '+', -- System clipboard
})
```

### Custom gthr Path

If you have gthr installed in a custom location:

```lua
require('gthr').setup({
  cmd = '/path/to/gthr',
  auto_install = false,
})
```

## How It Works

### Interactive Mode

When you run `:Gthr`, the plugin:
1. Checks if gthr is available (in PATH or auto-installed)
2. Opens a centered floating window
3. Spawns gthr's interactive TUI inside the window
4. Automatically closes the window when gthr exits

### Buffer Integration

`:GthrBuffers` does the same as above, but passes all currently open file buffers to gthr using the `-i` flag, so they're pre-selected in the fuzzy finder.

### Direct Mode

`:GthrGather` runs gthr in direct mode with all open buffers and copies the output directly to your system clipboard, without any UI interaction.

## Requirements

- Neovim >= 0.8.0
- `curl` (for auto-installation)
- `tar` or `unzip` (for extracting downloaded binaries)

The plugin will automatically download and install gthr on first use if `auto_install` is enabled (default).

## Supported Platforms

Auto-installation supports:
- macOS (Apple Silicon & Intel)
- Linux (x86_64)
- Windows (x86_64)

## Development

### Running Tests

```bash
# Run all tests
make test

# Run specific test file
make test-file FILE=tests/test_config.lua
```

Tests use [mini.test](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md) framework.

## License

MIT

## Credits

- [gthr](https://github.com/Adarsh-Roy/gthr) - The underlying CLI tool by Adarsh Roy
