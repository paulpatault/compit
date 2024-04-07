Mcompit = {}

local function file_exists(name)
   local f = io.open(name,"r")
   if f ~= nil then
       io.close(f)
       return true
   else
       return false
   end
end

local path = '$HOME/.local/share/nvim/compit_cache/'

local function get_file()
  local b = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  return vim.fs.normalize(path .. b);
end

local function get_command()
    local file = get_file();
    local e = vim.fn.fnamemodify(file, ":e")
    if e == "mlw" or e == "coma" then
      return "why3 ide %"
    end
    local command = "make -j4"
    if file_exists(file) then
        local file_obj = io.open(file, "r")
        io.input(file_obj)
        command = io.read()
        io.close(file_obj)
    else
        local file_obj = io.open(file, "w")
        io.output(file_obj)
        io.write(command)
        io.close(file_obj)
    end
    return command
end

local function set_command(command)
    local file = get_file();
    local file_obj = io.open(file, "w")
    io.output(file_obj)
    io.write(command)
    io.close(file_obj)
end

local function run_command(command)
    vim.cmd.AsyncRun(command)
end

local function run_with_prompt()
    local command = get_command()
    vim.ui.input({ prompt = "Command: ", default = command }, function(input)
        if input == nil then
            return
        end
        if command ~= input then
            command = input
            set_command(command)
        end
        run_command(command)
    end)
end

Mcompit.run = function(options)
  if options.prompt == nil then
    error("Usage: table (even empty) required -> run({})")
    return
  end
  if options.prompt == false then
    local c = get_command()
    print(c)
    run_command(c)
  else
    run_with_prompt()
  end
end

Mcompit.kill = function()
    vim.cmd.AsyncStop()
end

Mcompit.clear_cache = function()
  vim.cmd('!rm ' .. path .. '*')
end

Mcompit.init = function()
   local ok, err, code = os.rename(path, path)
   if not ok and code ~= 13 then
     vim.cmd('silent !mkdir -p ' .. path)
   end
   return ok, err
end

vim.keymap.set("n", "<localleader>bp",
  function() Mcompit.run({ prompt = true }) end, { desc = "[B]uild with [P]rompt" })

vim.keymap.set("n", "<localleader>bb",
  function() Mcompit.run({ prompt = false }) end, { desc = "[B]uild" })

vim.keymap.set("n", "<localleader>bk",
  function() Mcompit.kill() end, { desc = "[K]ill" })

vim.keymap.set("n", "<localleader>bcc",
  function() Mcompit.clear_cache() end, { desc = "[C]lear [C]ache" })

return Mcompit
