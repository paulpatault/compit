# Compit
Compit is a plugin for NeoVim to easily compile/run your code.

This repository is a fork of [paulfrische's Compit](github.com/paulfrische/compit),
adding support for background tasks.

### Usage

There is several ways to use this plugin.

With commands:
```lua
:Compit     command to run
:CompitSet  command to register
:CompitRun  -- cached command
:CompitKill
```

Within `lua`:
```lua
require('compit').run({})

-- to disable the prompt
require('compit').run({ prompt = false })

-- to kill the last command
require('compit').kill()

```

Or with a keybind:
```lua
vim.api.nvim_set_keymap('n', '<leader>c', ':lua require("compit").run({})<CR>', { noremap = true })
```

After running the compile/run command compit saves it and will put it in next
time you use compit.

### Usage
Default mappings are:
- `<localleader>bb` to run the registered command
- `<localleader>bp` to register a new command
- `<localleader>bk` to kill the command

### Installation
Lazy:
```lua
return {
  "paulpatault/compit",
  config = function()
    require('compit').init(
      { specials = { ext1 = "specific command", ... }
      }) end,
  dependencies = "skywind3000/asyncrun.vim"
}
```

You may want to add this autocommand to open the QuickFixList with the *botright* option.
```lua
vim.api.nvim_create_autocmd({"QuickFixCmdPost"},
  { pattern = "*",
    command = "botright copen 8",
    group = options_group, })
```

### Informations

The is one dependencies,
it is [Asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)
to run task in background.
