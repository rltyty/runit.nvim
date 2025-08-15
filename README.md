# runit.nvim
Neovim plugin for one-click code execution

## INTRODUCTION

This plugin makes running code in your current buffer lightning fast and
incredibly simple. Many popular languages like C, Java, Python, Go, JS, Perl,
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

## FAQ

### Multi-process Output Order Problem

`Runit` runs programs in Neovim's command mode, and sometimes you may find
that the output order is "unexpected". For example,

Suppose you run a C program like this — you expect the `date` output to come
after the welcome message, but it doesn't.

```c
...
printf("Main process says hi\n");
system("date");
// do some other stuff
...
```
- Running in Neovim
```sh
:!./Debug/test/a.out
Fri Aug 15 14:33:00 CST 2025
Main process says hi
```

- Running in a terminal,
```sh
> ./Debug/test/a.out
Main process says hi
Fri Aug 15 14:42:55 CST 2025
```

**Reason**: When executed in Neovim, the process's `stdout` stream is
connected to a pipe, not a terminal (TTY). The C standard library chooses the
buffer mode of the stream based on the file type. TTY -> line-buffered,
otherwise -> fully-buffered. Therefore, in Neovim, the output is
fully-buffered, whereas in a terminal it is line-buffered.

In the program above, although the `printf` message ends with `\n`
(which normally triggers a unbuffered `write(2)` system call immediately in a
terminal), in Neovim, it will not be written until either `fflush(stdout)` is
called explicitly or `exit()` automatically flushes and closes streams at
program termination.

Meanwhile, `system("date")` spawns (`fork()` + `exec()`) a child process to
run the `date` command. The child inherits (during `fork()`) a copy of its
parent's open file descriptors, including `STDOUT_FILENO`, which still points
to the same file table entry and further the same pipe. The child also inherits
the parent's file streams and their buffers, so the child's `stdout` buffer
also contains "Main process says hi". However, when `exec()` loads the `date`
program, the child gets fresh process image with new program `date`, fresh file
streams, empty buffers. After `date` is done, it `exit()`s with all
its file streams getting `flush()`ed and `close()`d, so we can see the
date output right way. As long as the parent finishes after the child, the output
order will appear "unexpected". In reality, it is exactly what buffering
rules dictate.

If you do need the "expected" order, either run the program in a terminal or
**change** the code:

- Explicit `fflush`

```c
printf("Main process says hi\n");
fflush(stdout);
system("date");
```

- Disable buffer for `stdout`

```c
setvbuf(stdout, NULL, _IONBF, 0);
```

