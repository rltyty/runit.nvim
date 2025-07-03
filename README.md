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

```lua
  require("runit").setup({
    key = true,             -- false: disable key mapping
    run_key = "<F4>",
    run_args_key = "<F16>", -- run with args input. <F-16> instead of <S-F4>
  })
```
