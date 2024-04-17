local M = require('compit')

-------------------------------------------------------------------------------

vim.keymap.set("n", "<localleader>bp",
  function() M.run({ prompt = true }) end, { desc = "[B]uild with [P]rompt" })

vim.keymap.set("n", "<localleader>bb",
  function() M.run({ prompt = false }) end, { desc = "[B]uild" })

vim.keymap.set("n", "<localleader>bk",
  function() M.kill() end, { desc = "[K]ill" })

vim.keymap.set("n", "<localleader>bcc",
  function() M.clear_cache() end, { desc = "[C]lear [C]ache" })

-------------------------------------------------------------------------------

vim.api.nvim_create_user_command(
  'Compit', function(input)
    if input == nil or input.fargs == nil then
        error("Usage: :Compit <task to run>")
        return
    end
    M.set_command(table.concat(input.fargs,' '))
    M.run({ prompt = false }) end,
  { nargs = '*', bang = true }
)

vim.api.nvim_create_user_command(
  'CompitRun',
  function(input) M.run({ prompt = false }) end,
  { bang = true }
)

vim.api.nvim_create_user_command(
  'CompitSet', function(input)
    if input.fargs == nil then
        error("Usage: :CompitSet <task to register>")
        return
    end
    M.set_command(table.concat(input.fargs,' ')) end,
  { nargs = '*', bang = true }
)

vim.api.nvim_create_user_command(
  'CompitKill',
  function(input) M.kill() end,
  { bang = true }
)

-------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({"User"},
  { pattern = "AsyncRunStart",
    command = "call asyncrun#quickfix_toggle(8, 1)",
    group = vim.api.nvim_create_augroup("CompitGroup", {clear = true}) })

-------------------------------------------------------------------------------
