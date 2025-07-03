-- runit.nvim
-- Author: rltyty <except10n.rlt@gmail.com>
-- Version: 1.0

--
-- Run the code in the current buffer or its corresponding executable.
--
-- Logic
local engines = {
  -- script like
  lua = 'lua',
  py = 'python',
  sh = 'sh',
  pl = 'perl',
  go = 'go run', -- Go is a compiled language, but `go run *.go` is a trick
  js = 'node',
  mjs = 'node',
  r = 'Rscript',

  -- script like, but complicated
  rmd = 'rmarkdown',

  -- executable, compilation required before run it
  c = 'c',
  java = 'java', -- JEP 330, Java 11, Launch Single-File Source-Code Programs
}

local cmd_strs = {}

cmd_strs.c = function()
  local targets = { 'Debug', 'Release', 'debug', 'release' }
  local binpath = vim.fn.expand '%:r'
  local root = vim.fs.root(0, targets)
  if root then
    for _, t in ipairs(targets) do
      local s = vim.uv.fs_stat(root .. '/' .. t)
      if s and s.type == 'directory' then
        -- e.g.
        -- root    = '/User/<login>/wksp/prjA'
        -- if
        -- binpath = '/User/<login>/wksp/prjA/mod/a'
        -- result  = '/User/<login>/wksp/prjA/Debug/mod/a'
        -- else
        -- binpath = 'mod/a"
        -- result  = 'Debug/mod/a'
        if string.match(binpath, '^' .. vim.pesc(root)) then
          binpath = vim.fn.fnamemodify(
            binpath,
            ':s?^' .. root .. '?' .. root .. '/' .. t .. '?'
          )
        else
          binpath = t .. '/' .. binpath
        end
        break
      end
    end
  else -- just simple code in flat structure without build targets
    -- if a path has no '/', then pathes in PATH are used to search
    if not string.find(binpath, '/') then
      binpath = './' .. binpath
    end
  end
  return binpath
end

cmd_strs.java = function()
  local cmd = {}
  local relpath = vim.fn.fnamemodify(vim.fn.expand '%:r', ':.')
  local cls = string.gsub(relpath, '/', '.')
  if vim.fs.root(0, { 'pom.xml' }) then
    cls = string.gsub(cls, 'src.%w+.java.', '') -- remove 'src/{main|test}/java'
    cmd = { 'java', '-cp target/classes:target/test-classes', cls }
  else
    cmd = { 'java', '-cp .', '%' } -- JEP 330: Launch Single-File Source-Code Programs
  end
  return table.concat(cmd, ' ')
end

cmd_strs.rmarkdown = function()
  return 'Rscript -e "rmarkdown::render(\'' .. vim.fn.expand '%' .. '\')"'
end

cmd_strs.script = function(e)
  return e .. ' ' .. vim.fn.expand '%'
end

local run_buf = function()
  vim.fn.setreg('c', '') -- clear named register "c
  local engine = engines[string.lower(vim.fn.expand '%:e')]
  if not engine then
    return
  end
  local cmd = '!'
  if engine == 'c' then             -- run c executable
    cmd = cmd .. cmd_strs.c()
  elseif engine == 'java' then      -- run java class
    cmd = cmd .. cmd_strs.java()
  elseif engine == 'rmarkdown' then -- run Rscript
    cmd = cmd .. cmd_strs.rmarkdown()
  else                              -- run normal script
    cmd = cmd .. cmd_strs.script(engine)
  end
  vim.fn.setreg('c', cmd) -- copy the cmd string to the named register 'c'
end

local function run_buf_no_args()
  run_buf()
  vim.cmd(":" .. vim.fn.getreg("c"))
end

local function run_buf_args()
  run_buf()
  vim.api.nvim_feedkeys(":" .. vim.fn.getreg("c") .. " ", "n", false)
end

-- Module
--
local M = {}

-- Default options
M.opts = {
  key = true,             -- false: disable key mapping
  run_key = "<F4>",
  run_args_key = "<F16>", -- run with args input. <F-16> instead of <S-F4>
}

-- Configuration
function M.setup(user_opts)
  M.opts = vim.tbl_extend("force", M.opts, user_opts or {})
  M.setup_keymap()
  M.create_commands()
end

-- Key map
function M.setup_keymap()
  if M.opts.key == false then return end
  if M.opts.run_key and M.opts.run_key ~= "" then
    vim.keymap.set("n", M.opts.run_key, run_buf_no_args,
      { desc = "Run buffer code", noremap = true, silent = true, })
  end
  if M.opts.run_args_key and M.opts.run_args_key ~= "" then
    vim.keymap.set("n", M.opts.run_args_key, run_buf_args,
      { desc = "Run buffer code (args)", noremap = true, silent = true, })
  end
end

function M.create_commands()
  vim.api.nvim_create_user_command("RunBuf", run_buf_no_args,
  { desc = "Run buffer code" })
  vim.api.nvim_create_user_command("RunBufArgs", run_buf_args,
  { desc = "Run buffer code (args)" })
end

return M
