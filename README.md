# runit.nvim
A Neovim plugin for running code in current buffer.

## INTRODUCTION

This plugin is a tool for running code in current buffer. Many popular
languages like C, Java, Python, Go, JS, Perl, Shell, Lua, R, Rmarkdown, etc.
are supported.

## Usage


|Command        |Default key mapping|Description|
|--------|-------------------           |-----------|
|`:RunBuf`| `<F4>`         |  Run the code|
| `:RunBufArgs` | `<F16>` (`SHIFT+<F4>` or `<S-F4>`) |Run the code with arguments|


## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
  {
    'rltyty/runit.nvim',
    config = function()
      require("runit").setup()
    end
  },
```

## CONFIGURATION

- Disable key mapping,

```lua
  require("runit").setup({
    key = false,
  })
```

- Change key mapping,

```lua
  require("runit").setup({
    run_key = "<F4>",
    run_args_key = "<F16>",
  })
```

