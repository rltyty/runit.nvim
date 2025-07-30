# runit.nvim
Neovim plugin for one-click code execution

## INTRODUCTION

This plugin makes running code in your current buffer lightning fast and
incredibly simple.. Many popular languages like C, Java, Python, Go, JS, Perl,
Shell, Lua, R, Rmarkdown, etc. are supported.

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

- Default options

```lua
-- Default options
M.opts = {
  key = true,             -- false: disable key mapping
  run_key = "<F4>",
  run_args_key = "<F16>", -- run with args input. <F-16> instead of <S-F4>
  src_prefix = "src",
  test_prefix = "src",
}
```

- Disable key mapping,

```lua
  require("runit").setup({
    key = false,
  })
```

- Change key mapping,

```lua
  require("runit").setup({
    run_key = "<F2>",
    run_args_key = "<F14>",
  })
```

- Project specific settings

Create a `.nvim.lua` (See `h: exrc`) under the project root directory.

```lua
  require("runit").setup({
    run_key = "<F2>",
    src_prefix = "source"
    test_prefix = "test"
  })
```
