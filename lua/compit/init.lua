M = {}

local function file_exists(name)
   local f = io.open(name,"r")
   if f ~= nil then
       io.close(f)
       return true
   else
       return false
   end
end

local function get_file()
  local b = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  return vim.fs.normalize('$XDG_CONFIG_HOME/nvim/compit_cache/compit_cache_' .. b);
end

local function get_command()
    local file = get_file();
    local command = "make"
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
        vim.opt.makeprg = command
        vim.cmd.make()
    end)
end

M.run = function(options)
    if options.prompt ~= nil then
        if options.prompt == false then
            local command = get_command()
            vim.opt.makeprg = command
            vim.cmd.make()
        else
            run_with_prompt()
        end
    else
        run_with_prompt()
    end
end


return M
