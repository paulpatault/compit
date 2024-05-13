local M = {}

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
local qf_height = 8

local user_table = {}

local function get_file()
  local b = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  return vim.fs.normalize(path .. b);
end

local function get_command()
    local file = get_file();
    local e = vim.fn.fnamemodify(vim.fn.expand('%'), ":e")
    for k, v in pairs(user_table) do
      if k == e then
        return v
      end
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

local function run(options)
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

local function kill()
    vim.cmd.AsyncStop()
end

local function clear_cache()
  vim.cmd('!rm ' .. path .. '*')
end

local function auto_cmd()
  vim.api.nvim_create_autocmd({"User"},
    { pattern = "AsyncRunStart",
      command = "call asyncrun#quickfix_toggle(" .. qf_height .. ", 1)",
      group = vim.api.nvim_create_augroup("CompitGroup", {clear = true}) })
end

local function setup(options)
  if options ~= nil then
    if options.path ~= nil then
      path = options.path
    end
    if options.qf_height ~= nil then
      qf_height = options.qf_height
    end
    if options.specials ~= nil then
      user_table = options.specials
    end
  end
  local ok, err, code = os.rename(path, path)
  if not ok and code ~= 13 then
    vim.cmd('silent !mkdir -p ' .. path)
  end
  auto_cmd()
  return ok, err
end

M = {
  setup = setup,
  run = run,
  kill = kill,
  clear_cache = clear_cache,
  set_command = set_command
}

return M
