# runit.nvim
A Neovim plugin for running code in current buffer.

## INTRODUCTION

This plugin is a tool for running code in current buffer. Many popular
languages like C, Java, Python, Go, Perl, Shell, Lua, Rmarkdown, etc. are
supported.

## COMMANDS

  `:RunBuf`                 Run the code

  `:RunBufArgs`             Run the code with arguments

## MAPPINGS

The default mapping:

  `<F4>`                    `:RunBuf`

  `<F16>`                   `:RunBufArgs`

NOTE: `<F16>` is `SHIFT + <F4>`

## CONFIGURATION

- With lazy.nvim,

```lua
  {
    'rltyty/runit.nvim',
    config = function()
      require("runit").setup()
    end
  },
```

- Customize key mapping

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

